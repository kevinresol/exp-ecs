package ecs.util;

import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.BuildCache;

using tink.MacroApi;
using StringTools;

class Macro {
	static var COMPONENT_TYPE = Context.getType('ecs.component.Component');
	public static function isComponent(type:haxe.macro.Type) {
		return type.isSubTypeOf(COMPONENT_TYPE).isSuccess();
	}
}