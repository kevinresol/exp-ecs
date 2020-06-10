package;

import system.*;
import entity.*;
import exp.ecs.Engine;
import exp.ecs.entity.*;
import exp.ecs.state.*;
import exp.ecs.system.*;
import exp.ecs.system.e2d.*;
import exp.fsm.*;
import util.*;
using tink.CoreApi;

class Main extends #if openfl openfl.display.Sprite #else luxe.Game #end {
	
	var state = new GameState();
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
		
		engine.systems.add(new GameSystem(config, state, function(_) return GameOver));
		engine.systems.add(new GunControlSystem(input));
		engine.systems.add(new MotionControlSystem(input));
		engine.systems.add(new TransformSystem());
		engine.systems.add(new CollisionSystem(Collision));
		engine.systems.add(new SpaceshipAsteroidCollisionHandlerSystem());
		engine.systems.add(new BulletAsteroidCollisionHandlerSystem());
		engine.systems.add(new LifespanSystem());
		engine.systems.add(new AnimationSystem());
		engine.systems.add(new DeathSystem());
		
		var fsm = StateMachine.create([
			new EngineState('playing', ['gameover'], engine, [
				{system: new MovementSystem(config), before: TransformSystem},
				{system: new TransformSystem(), before: CollisionSystem},
				{system: new VisualSystem(#if openfl this #end)},
			]),
			new EngineState('gameover', ['playing'], engine, []),
		]);
		
		engine.systems.add(EventHandlerSystem.simple(
			function(e) return e == GameOver ? Some(Noise) : None,
			function(_) return {
				fsm.transit('gameover');
				stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, function listener(e) {
					if(e.keyCode == openfl.ui.Keyboard.SPACE) {
						stage.removeEventListener(openfl.events.KeyboardEvent.KEY_DOWN, listener);
						state.reset();
						fsm.transit('playing');
					}
				});
			}
		));
	}
	
}

enum Event {
	Collision(data:{entity1:Entity, entity2:Entity, group1:Int, group2:Int});
	GameOver;
}