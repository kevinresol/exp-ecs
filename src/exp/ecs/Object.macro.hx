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

	public macro function add(ethis:Expr, e:Expr, args:Array<Expr>) {
		final type = Context.typeof(macro exp.ecs.macro.Helper.get($e));
		final tp = e.toString().asTypePath();
		return macro @:privateAccess $ethis.addComponent(new $tp($a{args}));
	}
}
