package exp.ecs.macro;

import exp.ecs.*;

@:dce
class Helper {
	public static function get<T:Component>(c:Class<T>):T {
		throw 0;
	}
}