package exp.ecs;

import haxe.macro.Expr;
import haxe.macro.Context;

using tink.MacroApi;

class Object {
	public macro function get(ethis:Expr, e:Expr) {
		final type = Context.typeof(macro exp.ecs.macro.Helper.get($e));
		final ct = type.toComplex();
		return macro(cast @:privateAccess $ethis.getComponent($e) : Null<$ct>);
	}
}
