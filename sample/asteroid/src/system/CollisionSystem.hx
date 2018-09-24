package system;

import component.*;
import ecs.system.*;
import ecs.node.*;
import util.*;

class CollisionSystem extends System {
	@:nodes var spaceships:Node<Spaceship, Position, Collision>;
	@:nodes var asteroids:Node<Asteroid, Position, Collision>;
	@:nodes var bullets:Node<Bullet, Position, Collision>;
	
	override function update(dt:Float) {
		for(bullet in bullets) for(asteroid in asteroids) {
			if(Point.distance(asteroid.position.position, bullet.position.position) <= asteroid.collision.radius) {
				if(asteroid.collision.radius > 10) {
					engine.addEntity(new entity.Asteroid(asteroid.collision.radius - 10, asteroid.position.position.x + Math.random() * 10 - 5, asteroid.position.position.y + Math.random() * 10 - 5));
					engine.addEntity(new entity.Asteroid(asteroid.collision.radius - 10, asteroid.position.position.x + Math.random() * 10 - 5, asteroid.position.position.y + Math.random() * 10 - 5));
				}
				engine.removeEntity(bullet.entity);
				engine.removeEntity(asteroid.entity);
				break;
			}
		}
		
		for(spaceship in spaceships) for(asteroid in asteroids) {
			if(Point.distance(asteroid.position.position, spaceship.position.position) <= asteroid.collision.radius + spaceship.collision.radius) {
				spaceship.spaceship.fsm.change('destroyed');
				break;
			}
		}
	}
}
