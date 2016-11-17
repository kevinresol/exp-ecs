package system;

import ecs.*;
import ecs.Node;
import node.Nodes;
import util.*;

class GameSystem implements System {
	
	var engine:Engine;
	var config:Config;
	var gameNodes:NodeList<GameNode>;
	var spaceships:NodeList<SpaceshipNode>;
	// var asteroids:NodeList<AsteroidNode>;
	
	public function new(engine, config) {
		this.engine = engine;
		this.config = config;
	}
	
	public function onAdded(engine:Engine) {
		gameNodes = engine.getNodeList(GameNode);
		spaceships = engine.getNodeList(SpaceshipNode);
	}
	
	public function onRemoved(engine:Engine) {
		
	}
	
	public function update(dt:Float) {
		for(node in gameNodes) {
			if(spaceships.empty) {
				if(node.game.lives > 0) {
					var newPos = new Point(config.width * 0.5, config.height * 0.5);
					var clear = true;
					// for(asteroid in asteroids) {
					// 	if(Point.distance(asteroid.position.coordinate, newPos) <= asteroid.collision.radius + 50) {
					// 		clear = false;
					// 		break;
					// 	}
					// }
					if(clear) {
						engine.addEntity(new entity.Spaceship());
						node.game.lives--;
					}
				}
			}
		}
	}
	
	public function toString()
		return Type.getClassName(Type.getClass(this));
}
