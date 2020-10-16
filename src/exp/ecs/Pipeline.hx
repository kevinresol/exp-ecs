package exp.ecs;

using Lambda;

@:allow(exp.ecs)
class Pipeline {
	final phases:Array<Phase>;
	final world:World;

	public function new(world:World, phases:Array<Int>) {
		this.world = world;
		this.phases = phases.map(Phase.new);
		this.phases.sort((v1, v2) -> v1.id - v2.id);
	}

	public function add(phase:Int, system:System) {
		switch phases.find(v -> v.id == phase) {
			case null:
				throw 'Unknown phase $phase';
			case phase:
				phase.systems.push(system);
		}
	}

	inline function update(dt:Float) {
		for (phase in phases)
			phase.update(dt);
	}
}

@:allow(exp.ecs)
class Phase {
	public final id:Int;
	public final systems:Array<System> = [];

	public function new(id) {
		this.id = id;
	}

	inline function update(dt:Float) {
		for (system in systems)
			system.update(dt);
	}
}
