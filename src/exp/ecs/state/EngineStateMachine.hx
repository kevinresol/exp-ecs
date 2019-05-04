package exp.ecs.state;

import exp.ecs.*;
import exp.ecs.state.FiniteStateMachine;
import exp.ecs.state.EngineState;

class EngineStateMachine<Event> extends FiniteStateMachine<Engine<Event>, SystemInfo<Event>> {
	override function removeFromTarget(infos:Array<SystemInfo<Event>>) 
		for(info in infos) target.systems.remove(info.system);
	
	override function addToTarget(infos:Array<SystemInfo<Event>>)
		for(info in infos) target.systems.addBetween(info.before, info.after, info.system, info.id);
}
