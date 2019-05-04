package exp.ecs.state;

import exp.ecs.entity.*;
import exp.ecs.component.*;

class EntityStateMachine extends FiniteStateMachine<Entity, Component> {
	override function removeFromTarget(components:Array<Component>)
		for(component in components) target.remove(component);
	
	override function addToTarget(components:Array<Component>)
		for(component in components) target.add(component);
}
