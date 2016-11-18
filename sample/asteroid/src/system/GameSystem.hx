package system;

import component.*;
import ecs.*;
import ecs.Node;
import util.*;

private typedef GameNode = Node<Game>;
private typedef SpaceshipNode = Node<Spaceship, Position>;
private typedef AsteroidNode = Node<Asteroid, Position, Collision>;
private typedef BulletNode = Node<Bullet>;

class GameSystem extends System {
	
	var config:Config;
	var gameNodes:NodeList<GameNode>;
	var spaceships:NodeList<SpaceshipNode>;
	var asteroids:NodeList<AsteroidNode>;
	var bullets:NodeList<BulletNode>;
	
	public function new(config) {
		super();
		this.config = config;
	}
	
	override function onAdded(engine:Engine) {
		super.onAdded(engine);
		gameNodes = engine.getNodeList(GameNode);
		spaceships = engine.getNodeList(SpaceshipNode);
		asteroids = engine.getNodeList(AsteroidNode);
		bullets = engine.getNodeList(BulletNode);
	}
	
	override function onRemoved(engine:Engine) {
		super.onRemoved(engine);
		gameNodes = null;
		spaceships = null;
		asteroids = null;
		bullets = null;
	}
	
	override function update(dt:Float) {
		for(node in gameNodes) {
			if(spaceships.empty) {
				if(node.game.lives > 0) {
					var newPos = new Point(config.width * 0.5, config.height * 0.5);
					var clear = true;
					for(asteroid in asteroids) {
						if(Point.distance(asteroid.position.position, newPos) <= asteroid.collision.radius + 50) {
							clear = false;
							break;
						}
					}
					if(clear) {
						engine.addEntity(new entity.Spaceship());
						node.game.lives--;
					}
				} else {
					// game over
				}
			}
			
			if(asteroids.empty && bullets.empty && !spaceships.empty) {
				// next level
				var spaceship = spaceships.head;
				node.game.level++;
				for(i in 0... 2 + node.game.level) {
					var position = null;
					do position = new Point(Math.random() * config.width, Math.random() * config.height)
					while(Point.distance(position, spaceship.position.position) < 80);
					engine.addEntity(new entity.Asteroid(30, position.x, position.y));
				}
			}
		}
	}
}
