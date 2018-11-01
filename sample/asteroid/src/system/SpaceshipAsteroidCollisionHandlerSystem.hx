package system;

import ecs.entity.*;
import ecs.system.*;
import Main;

class SpaceshipAsteroidCollisionHandlerSystem extends EventHandlerSystem<Event, Entity> {
	public function new() {
		super(
			(e:Event) -> switch e {
				case Collision({entity2: entity, group2: group}) | Collision({entity1: entity, group1: group}) if(group == 1): Some(entity);
				case _: None;
			}, 
			(entity:Entity) -> {
				var spaceship = entity.get(component.Spaceship);
				spaceship.fsm.change('destroyed');
			}
		);
	}
}