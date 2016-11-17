package entity;

import openfl.ui.Keyboard;
import component.*;
import ecs.*;
import ecs.EntityStateMachine;
import openfl.display.*;

abstract Spaceship(Entity) to Entity {
	public function new() {
		var e = new Entity();
		var fsm = new EntityStateMachine(e);
		
		var playing = new EntityState();
		playing.add(Motion, new Motion(0, 0, 0, 15));
		playing.add(MotionControls, new MotionControls(Keyboard.LEFT, Keyboard.RIGHT, Keyboard.UP, 100, 3));
		fsm.add('playing', playing);
		e.add(new component.Spaceship(fsm));
		e.add(new Position(250, 250, 0));
		
		var bitmap = new Bitmap(new BitmapData(100,100,false,0xff0000));
		bitmap.x = bitmap.y = -50;
		var sprite = new Sprite();
		sprite.graphics.lineStyle(2, 0);
		sprite.graphics.moveTo(20, 0);
		sprite.graphics.lineTo(-20, -10);
		sprite.graphics.lineTo(-10, 0);
		sprite.graphics.lineTo(-20, 10);
		sprite.graphics.lineTo(20, 0);
		e.add(new Display(sprite));
		
		fsm.change('playing');
		
		this = e;
	}
}