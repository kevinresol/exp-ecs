package system;

import ecs.entity.*;
import ecs.system.*;
import Main;

class SpaceshipAsteroidCollisionHandlerSystem extends EventHandlerSystem<Event, Entity> {
	public function new() {
		super(
			e -> switch e {
				case Collision({entity2: e, group2: g}) | Collision({entity1: e, group1: g}) if(g == 1): Some(e);
				case _: None;
			}, 
			entity -> {
				var spaceship = entity.get(component.Spaceship);
				spaceship.fsm.change('destroyed');
			}
		);
	}
}