package exp.ecs;

import haxe.display.Display.Package;
import exp.ecs.World;

class Engine {

	public final worlds:WorldCollection = new WorldCollection();

	public function new() {}

	public inline function update(dt:Float) {
		tink.state.Scheduler.atomically(() -> worlds.update(dt));
	}
}

@:allow(exp.ecs)
class WorldCollection {
	static var ids:Int = 0;

	final worlds:Map<Int, World> = [];

	function new() {}

	public function create(phases) {
		final world = new World(ids++, phases);
		worlds.set(world.id, world);
		return world;
	}

	public function get(id:Int) {
		return worlds.get(id);
	}

	inline function update(dt:Float) {
		for (world in worlds)
			world.update(dt);
	}
}
