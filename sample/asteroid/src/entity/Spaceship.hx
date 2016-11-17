package entity;

import openfl.ui.Keyboard;
import component.*;
import ecs.*;
import ecs.EntityStateMachine;
import openfl.display.*;

abstract Spaceship(Entity) to Entity {
	public function new() {
		this = new Entity();
		
		var fsm = new EntityStateMachine(this);
		var playing = new EntityState();
		playing.add(Motion, new Motion(0, 0, 0, 15));
		playing.add(MotionControls, new MotionControls(Keyboard.LEFT, Keyboard.RIGHT, Keyboard.UP, 100, 3));
		fsm.add('playing', playing);
		fsm.change('playing');
		
		var sprite = new Sprite();
		sprite.graphics.lineStyle(2, 0);
		sprite.graphics.moveTo(20, 0);
		sprite.graphics.lineTo(-20, -10);
		sprite.graphics.lineTo(-10, 0);
		sprite.graphics.lineTo(-20, 10);
		sprite.graphics.lineTo(20, 0);
		
		this.add(new Position(250, 250, 0));
		this.add(new component.Spaceship(fsm));
		this.add(new Gun(8, 0, 0.3, 2));
		this.add(new GunControls(Keyboard.SPACE));
		this.add(new Display(sprite));
	}
}