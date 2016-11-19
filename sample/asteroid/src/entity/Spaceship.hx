package entity;

import openfl.ui.Keyboard;
import component.*;
import ecs.*;
import ecs.Component;
import ecs.EntityStateMachine;
import openfl.display.*;

abstract Spaceship(Entity) to Entity {
	public function new(x, y) {
		this = new Entity();
		
		var fsm = new EntityStateMachine(this);
		var playing = new EntityState();
		playing.add(Motion, new Motion(0, 0, 0, 15));
		playing.add(MotionControls, new MotionControls(Keyboard.LEFT, Keyboard.RIGHT, Keyboard.UP, 100, 3));
		playing.add(Display, new Display(new graphic.SpaceshipView()).asProvider('alive'));
		playing.add(Gun, new Gun(8, 0, 0.3, 2));
		playing.add(GunControls, new GunControls(Keyboard.SPACE));
		playing.add(Collision, new Collision(9));
		fsm.add('playing', playing);
		fsm.change('playing');
		
		var destroyed = new EntityState();
		var view = new graphic.SpaceshipDeathView();
		destroyed.add(Display, new Display(view).asProvider('dead'));
		destroyed.add(Animation, new Animation(view));
		destroyed.add(Death, new Death(2));
		fsm.add('destroyed', destroyed);
		
		this.add(new Position(x, y, 0));
		this.add(new component.Spaceship(fsm));
	}
}