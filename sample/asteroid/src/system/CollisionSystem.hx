package system;

import component.*;
import ecs.*;
import ecs.Node;
import util.*;

private typedef SpaceshipNode = Node<Spaceship, Position, Collision>;
private typedef AsteroidNode = Node<Asteroid, Position, Collision>;
private typedef BulletNode = Node<Bullet, Position, Collision>;

class CollisionSystem extends System {
	
	var spaceships:NodeList<SpaceshipNode>;
	var asteroids:NodeList<AsteroidNode>;
	var bullets:NodeList<BulletNode>;
	
	override function onAdded(engine:Engine) {
		super.onAdded(engine);
		spaceships = engine.getNodeList(SpaceshipNode);
		asteroids = engine.getNodeList(AsteroidNode);
		bullets = engine.getNodeList(BulletNode);
	}
	
	override function onRemoved(engine:Engine) {
		super.onRemoved(engine);
		spaceships = null;
		asteroids = null;
		bullets = null;
	}
	
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
