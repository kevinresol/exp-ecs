package;

import ecs.Engine;
import system.*;
import entity.*;
import ecs.entity.*;
import util.*;
using tink.CoreApi;

class Main extends #if openfl openfl.display.Sprite #else luxe.Game #end {
	
	var engine = new Engine<Event>();
	var input = new Input();
	
	#if openfl
	
		public function new() {
			super();
			stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, function(e) input.keyDown(e.keyCode));
			stage.addEventListener(openfl.events.KeyboardEvent.KEY_UP, function(e) input.keyUp(e.keyCode));
			start(input);
			
			var time = haxe.Timer.stamp();
			this.addEventListener(openfl.events.Event.ENTER_FRAME, function(_) {
				var now = haxe.Timer.stamp();
				engine.update(now - time);
				time = now;
			});
		}
	
	#elseif luxe
		override function config(config:luxe.GameConfig) {
			config.render.antialiasing = 4;
			return config;
		}
		
		override function ready() {
			start(input);
		}
		
		override function onkeyup(event:luxe.Input.KeyEvent) {
			if(event.keycode == luxe.Input.Key.escape) {
				Luxe.shutdown();
			} else input.keyUp(event.keycode);
		}
		
		override function onkeydown(event:luxe.Input.KeyEvent) {
			input.keyDown(event.keycode);
		}
		
		override function update(dt:Float) {
			engine.update(dt);
		}
		
	#end
	
	function start(input) {
		var config = {
			width: #if openfl stage.stageWidth #elseif luxe Luxe.screen.w #end,
			height: #if openfl stage.stageHeight #elseif luxe Luxe.screen.h #end,
		};
		
		engine.systems.add(new GameSystem(config));
		engine.systems.add(new GunControlSystem(input));
		engine.systems.add(new MotionControlSystem(input));
		engine.systems.add(new MovementSystem(config));
		engine.systems.add(new CollisionSystem(Collision));
		engine.systems.add(new EventHandlerSystem(
			(e:Event) -> switch e {
				case Collision(v): Some(v);
				case _: None;
			}, 
			(pair:Pair<Entity, Entity>) -> {
				var c1:component.Collision = pair.a.get(component.Collision);
				var c2:component.Collision = pair.b.get(component.Collision);
				function hasGroup(v:Int) return c1.groups.indexOf(v) != -1 && c2.groups.indexOf(v) != -1;
				function with(c) return pair.a.has(c) ? pair.a : pair.b.has(c) ? pair.b : null;
				if(hasGroup(0)) {
					var spaceship = with(component.Spaceship).get(component.Spaceship);
					spaceship.fsm.change('destroyed');
				} else if(hasGroup(1)) {
					var entity = with(component.Asteroid);
					var radius = entity.get(component.Asteroid).radius;
					var position = entity.get(component.Position).position;
					
					if(radius > 10) {
						engine.entities.add(new entity.Asteroid(radius - 10, position.x + Math.random() * 10 - 5, position.y + Math.random() * 10 - 5));
						engine.entities.add(new entity.Asteroid(radius - 10, position.x + Math.random() * 10 - 5, position.y + Math.random() * 10 - 5));
					}
					
					engine.entities.remove(pair.a);
					engine.entities.remove(pair.b);
				}
			}
		));
		engine.systems.add(new LifespanSystem());
		engine.systems.add(new AnimationSystem());
		engine.systems.add(new DeathSystem());
		engine.systems.add(new RenderSystem(#if openfl this #end));
		
		engine.entities.add(new Game());
	}
	
}

enum Event {
	Collision(pair:Pair<Entity, Entity>);
}