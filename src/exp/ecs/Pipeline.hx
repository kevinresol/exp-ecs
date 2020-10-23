package exp.ecs;

import tink.core.Callback.CallbackLink;

using Lambda;

@:allow(exp.ecs)
class Pipeline {
	final phases:Array<Phase>;
	final world:World;

	public function new(world:World, phases:Array<PhaseDecl>) {
		this.world = world;
		this.phases = [
			for (decl in phases)
				switch decl.type {
					case VariableTimestep:
						new Phase(decl.id);
					case FixedTimestep(delta):
						new FixedTimestepPhase(decl.id, delta);
				}
		];
		this.phases.sort((v1, v2) -> v1.id - v2.id);
	}

	@:nullSafety(Off)
	public function add(phase:Int, system:System):CallbackLink {
		return switch phases.find(v -> v.id == phase) {
			case null:
				throw 'Unknown phase $phase';
			case phase:
				phase.systems.push(system);
				[system.initialize(), ()->phase.systems.remove(system)];
		}
	}

	inline function update(dt:Float) {
		for (phase in phases)
			phase.update(dt);
	}
}

@:forward
abstract PhaseDecl(PhaseDeclBase) from PhaseDeclBase to PhaseDeclBase {
	@:from
	public static inline function fromInt(id:Int):PhaseDecl
		return ({id: id, type: VariableTimestep} : PhaseDeclBase);
}

@:structInit
class PhaseDeclBase {
	public final id:Int;
	public final type:PhaseType;
}

enum PhaseType {
	VariableTimestep;
	FixedTimestep(delta:Float);
}

class Phase {
	public final id:Int;
	public final systems:Array<System> = [];

	public function new(id) {
		this.id = id;
	}

	public function update(dt:Float) {
		for (system in systems)
			system.update(dt);
	}
}

class FixedTimestepPhase extends Phase {
	final delta:Float;
	var residue:Float = 0;

	public function new(id, delta) {
		super(id);
		this.delta = delta;
	}

	override function update(dt:Float) {
		residue += dt;
		while (residue > delta) {
			super.update(delta);
			residue -= delta;
		}
	}
}
