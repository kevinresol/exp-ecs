package exp.ecs;

import haxe.macro.Context;

using tink.MacroApi;
using Lambda;

class Component {
	public static function build() {
		final builder = new ClassBuilder();
		final fqcn = Context.getLocalClass().toString();

		if (builder.target.superClass != null)
			builder.target.pos.error('Component extending another class is currently not supported');

		builder.addMembers(macro class {
			public var signature(get, never):exp.ecs.Signature;

			inline function get_signature() {
				// TODO: make sure compile-time fqcn is always equal to runtime Type.getClassName()
				return @:privateAccess new exp.ecs.Signature($v{fqcn});
			}

			@:keep
			public function toString() {
				return $v{builder.target.name}
			}
		});

		final initials = [
			for (f in builder) {
				switch f.kind {
					case FVar(_, e) | FProp(_, 'null' | 'default', _, e) if (f.isPublic
						&& !f.isStatic
						&& !f.meta.exists(m -> m.name == ':noinit')):
						{field: f, optional: e != null};
					case _:
						continue;
				}
			}
		];

		final ctor = builder.getConstructor({
			args: [for (init in initials) {name: init.field.name, opt: init.optional, type: null}],
			expr: macro $b{
				[
					for (init in initials) {
						final name = init.field.name;
						final e = macro this.$name = $i{name};
						if (init.optional)
							(macro if ($i{name} != null)
								$e);
						else
							e;
					}
				]
			},
			ret: null,
		});
		ctor.publish();

		if (!builder.hasMember('clone')) {
			builder.addMember({
				name: 'clone',
				access: [APublic],
				kind: FFun({
					final args = ctor.getArgList().map(arg -> macro $i{arg.name});
					final tp = builder.target.name.asTypePath();
					(macro new $tp($a{args})).func();
				}),
				pos: Context.currentPos(),
			});
		}

		for (member in builder) {
			if (member.isPublic && member.isStatic && member.meta.exists(m -> m.name == ':link'))
				switch member.kind {
					case FVar(_, null):
						final value = '$fqcn:${member.name}';
						member.kind = FVar(macro:String, macro $v{value});
					case _:
				}
		}

		return builder.export();
	}
}
