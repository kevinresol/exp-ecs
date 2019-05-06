package exp.ecs.state;

import exp.fsm.*;
import exp.ecs.system.*;

class EngineState<T, Event> extends State<T> {
	var engine:Engine<Event>;
	var infos:Array<SystemInfo<Event>>;
	
	public function new(key, next, engine, infos) {
		super(key, next);
		this.engine = engine;
		this.infos = infos;
	}
	
	override function onActivate() {
		for(info in infos) engine.systems.addBetween(info.before, info.after, info.system, info.id);
	}
	
	override function onDeactivate() {
		for(info in infos) engine.systems.remove(info.system);
	}
}

typedef SystemInfo<Event> = {system:System<Event>, ?before:SystemId, ?after:SystemId, ?id:SystemId}
