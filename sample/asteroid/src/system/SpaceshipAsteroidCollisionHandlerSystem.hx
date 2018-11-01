package system;

import ecs.entity.*;
import ecs.system.*;
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
		var spaceship = entity.get(component.Spaceship);
		spaceship.fsm.change('destroyed');
	}
}