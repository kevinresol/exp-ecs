package ecs.state;

import ecs.entity.*;
import ecs.component.*;

class EntityStateMachine extends FiniteStateMachine<Entity, Component> {
	override function removeFromTarget(components:Array<Component>)
		for(component in components) target.remove(component);
	
	override function addToTarget(components:Array<Component>)
		for(component in components) target.add(component);
}
