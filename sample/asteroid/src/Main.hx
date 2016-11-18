package;

import ecs.Engine;
import system.*;
import entity.*;
import util.*;

class Main extends openfl.display.Sprite {
	public function new() {
		super();
		var engine = new Engine();
		var config = {width: stage.stageWidth, height: stage.stageHeight};
		graphics.beginFill(0);
		graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		graphics.endFill();
		var input = new Input(stage);
		
		engine.addSystem(new GameSystem(config));
		engine.addSystem(new GunControlSystem(input));
		engine.addSystem(new MotionControlSystem(input));
		engine.addSystem(new MovementSystem(config));
		engine.addSystem(new CollisionSystem());
		engine.addSystem(new BulletSystem());
		engine.addSystem(new AnimationSystem());
		engine.addSystem(new DeathSystem());
		engine.addSystem(new RenderSystem(this));
		
		engine.addEntity(new Game());
		
		var time = haxe.Timer.stamp();
		this.addEventListener(openfl.events.Event.ENTER_FRAME, function(_) {
			var now = haxe.Timer.stamp();
			engine.update(now - time);
			time = now;
		});
		
	}
	
}
