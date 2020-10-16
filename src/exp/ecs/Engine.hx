package exp.ecs;

import exp.ecs.World;

class Engine {
	public final worlds:WorldCollection = new WorldCollection();

	public function new() {}
}

@:allow(exp.ecs)
class WorldCollection {
	static var ids:Int = 0;

	final map:Map<Int, World> = [];

	function new() {}

	public function create() {
		final world = new World(ids++);
		map.set(world.id, world);
		return world;
	}

	public function get(id:Int) {
		return map.get(id);
	}
}
