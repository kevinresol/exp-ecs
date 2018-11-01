package system;

import ecs.entity.*;
import ecs.system.*;
import Main;
using tink.CoreApi;

class BulletAsteroidCollisionHandlerSystem extends EventHandlerSystem<Event, Pair<Entity, Entity>> {
	public function new() {
		super(
			e -> switch e {
				case Collision({entity1: e2, entity2: e1, group2: g}) | Collision({entity1: e1, entity2: e2, group1: g}) if(g == 2): Some(new Pair(e1, e2));
				case _: None;
			}, 
			pair -> {
				var bullet = pair.a;
				var asteroid = pair.b;
				var radius = asteroid.get(component.Asteroid).radius;
				var position = asteroid.get(component.Position).position;
				
				if(radius > 10) {
					engine.entities.add(new entity.Asteroid(radius - 10, position.x + Math.random() * 10 - 5, position.y + Math.random() * 10 - 5));
					engine.entities.add(new entity.Asteroid(radius - 10, position.x + Math.random() * 10 - 5, position.y + Math.random() * 10 - 5));
				}
				
				engine.entities.remove(bullet);
				engine.entities.remove(asteroid);
			}
		);
	}
}