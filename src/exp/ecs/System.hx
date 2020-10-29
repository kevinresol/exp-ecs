package exp.ecs;

import tink.core.Callback.CallbackLink;

@:allow(exp.ecs)
class System {
	function update(dt:Float) {}

	@:nullSafety(Off)
	function initialize(world:World):CallbackLink {
		return null;
	}

	public static macro function single(name, world, query, f);

	public static inline function simple(name, f) {
		return new exp.ecs.system.SimpleSystem(name, f);
	}
}
