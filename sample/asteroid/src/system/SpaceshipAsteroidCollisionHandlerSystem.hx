package system;

import exp.ecs.entity.*;
import exp.ecs.system.*;
import Main;
using tink.CoreApi;

class SpaceshipAsteroidCollisionHandlerSystem extends EventHandlerSystem<Event, Entity> {
	override function select(e:Event) {
		return switch e {
			case Collision({entity2: e, group2: g}) | Collision({entity1: e, group1: g}) if(g == 1): Some(e);
			case _: None;
		}
	}
	
	override function handle(entity:Entity) {
		entity.get(component.Spaceship).fsm.transit('destroyed');
	}
}