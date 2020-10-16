package exp.ecs;

import haxe.macro.Context;

using tink.MacroApi;
using Lambda;

class Component {
	public static function build() {
		final builder = new ClassBuilder();

		if (builder.target.superClass != null)
			builder.target.pos.error('Component extending another class is currently not supported');

		builder.addMembers(macro class {
			public var signature(get, never):exp.ecs.Signature;

			inline function get_signature():exp.ecs.Signature {
				return this;
			}
		});

		final initials = [
			for (f in builder) {
				switch f.kind {
					case FVar(_) | FProp(_, 'null' | 'default', _, _) if (f.isPublic && !f.meta.exists(m -> m.name == ':noinit')):
						f;
					case _:
						continue;
				}
			}
		];

		final ctor = builder.getConstructor({
			args: [for (v in initials) {name: v.name, type: null}],
			expr: macro $b{
				[
					for (v in initials) {
						final name = v.name;
						macro this.$name = $i{name};
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
					var args = ctor.getArgList().map(arg -> macro $i{arg.name});
					var tp = builder.target.name.asTypePath();
					(macro new $tp($a{args})).func();
				}),
				pos: Context.currentPos(),
			});
		}

		return builder.export();
	}
}
