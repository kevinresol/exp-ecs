package entity;

import component.*;
import ecs.*;
import ecs.EntityStateMachine;
import openfl.display.*;

abstract Spaceship(Entity) to Entity {
	public function new() {
		var e = new Entity();
		var fsm = new EntityStateMachine(e);
		
		var playing = new EntityState();
		playing.add(Motion, new Motion(0, 0, 1, 15));
		playing.add(MotionControls, new MotionControls(1,1,1,1,1));
		fsm.add('playing', playing);
		e.add(new component.Spaceship(fsm));
		e.add(new Position(250, 250, 0));
		e.add(new Display(new Bitmap(new BitmapData(100,100,false,0xff0000))));
		
		fsm.change('playing');
		
		this = e;
	}
}