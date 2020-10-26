package exp.ecs;

import tink.core.Callback.CallbackLink;

@:allow(exp.ecs)
class System {
	function update(dt:Float) {}

	@:nullSafety(Off)
	function initialize(world:World):CallbackLink {
		return null;
	}

	public static macro function simple(name, world, query, f);
}
