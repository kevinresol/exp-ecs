package system;

import component.*;
import exp.ecs.event.*;
import exp.ecs.system.*;
import exp.ecs.component.e2d.*;
import exp.ecs.node.*;
import util.*;

using tink.CoreApi;

class GameSystem<Event> extends System<Event> {
	@:nodes var spaceships:Node<Spaceship, Transform>;
	@:nodes var asteroids:Node<Asteroid, Transform, Collision>;
	@:nodes var bullets:Node<Bullet>;
	
	var config:Config;
	var game:GameState;
	var gameover:EventFactory<Event, Noise>;
	
	public function new(config, game, gameover) {
		super();
		this.config = config;
		this.game = game;
		this.gameover = gameover;
	}
	
	override function update(dt:Float) {
		if(!game.over) {
			if(spaceships.empty) {
				if(game.lives > 0) {
					var x = config.width * 0.5;
					var y = config.height * 0.5;
					var clear = true;
					for(asteroid in asteroids) {
						if(distance(asteroid.transform.global.tx, asteroid.transform.global.ty, x, y) <= asteroid.collision.radius + 50) {
							clear = false;
							break;
						}
					}
					if(clear) {
						engine.entities.add(new entity.Spaceship(x, y));
						game.lives--;
					}
				} else {
					// game over
					trace('Game Over');
					game.over = true;
					engine.events.afterEngineUpdate(gameover(Noise));
				}
			}
				
			if(asteroids.empty && bullets.empty && !spaceships.empty) {
				// next level
				var spaceship = spaceships.head;
				game.level++;
				for(i in 0... 2 + game.level) {
					var x, y;
					do {
						x = Math.random() * config.width;
						y = Math.random() * config.height;
					} while(distance(x, y, spaceship.transform.global.tx, spaceship.transform.global.ty) < 80);
					engine.entities.add(new entity.Asteroid(30, x, y));
				}
			}
		}
	}
	
	
	static function distance(x1:Float, y1:Float, x2:Float, y2:Float) {
		var dx = x1 - x2;
		var dy = y1 - y2;
		return Math.sqrt(dx * dx + dy * dy);
	}
}
