package exp.ecs;

using tink.MacroApi;
using Lambda;

abstract Signature(String) {
	public static macro function ofExpr(e) {
		return switch haxe.macro.Context.typeof(e) {
			case TType(_.get() => {type: TAnonymous(_.get() => {status: AClassStatics(cls = _.get() => {interfaces: interfaces})})}, _)
				if (interfaces.exists(i -> i.t.toString() == 'exp.ecs.Component')):
				macro @:privateAccess new exp.ecs.Signature($v{cls.toString()});
			case _:
				e.pos.error('Expected Class<T> where T implements exp.ecs.Component');
		}
	}
}
