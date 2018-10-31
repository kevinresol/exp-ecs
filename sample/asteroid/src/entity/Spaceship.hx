package entity;

import component.*;
import ecs.entity.*;
import ecs.component.*;

abstract Spaceship(Entity) to Entity {
	public function new(x, y) {
		this = new Entity();
		
		var left = #if openfl openfl.ui.Keyboard.LEFT #elseif luxe luxe.Input.Key.left #end;
		var right = #if openfl openfl.ui.Keyboard.RIGHT #elseif luxe luxe.Input.Key.right #end;
		var up = #if openfl openfl.ui.Keyboard.UP #elseif luxe luxe.Input.Key.up #end;
		var space = #if openfl openfl.ui.Keyboard.SPACE #elseif luxe luxe.Input.Key.space #end;
		
		var fsm = new EntityStateMachine(this);
		var playing = new EntityState();
		playing.add(Motion, new Motion(0, 0, 0, 15));
		playing.add(MotionControls, new MotionControls(left, right, up, 100, 3));
		playing.add(Display, new Display(new graphic.SpaceshipView()).asProvider('alive'));
		playing.add(Gun, new Gun(8, 0, 0.3, 2));
		playing.add(GunControls, new GunControls(space));
		playing.add(Collision, new Collision([0], 9));
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