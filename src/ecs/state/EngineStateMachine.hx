package ecs.state;

import ecs.*;
import ecs.system.*;

class EngineStateMachine<Event> extends FiniteStateMachine<Engine<Event>, System<Event>> {
	override function removeFromTarget(systems:Array<System<Event>>)
		for(system in systems) target.systems.remove(system);
	
	override function addToTarget(systems:Array<System<Event>>)
		for(system in systems) target.systems.add(system);
}
