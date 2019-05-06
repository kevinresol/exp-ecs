package entity;

import component.*;
import exp.ecs.entity.*;
import exp.ecs.component.*;
import exp.ecs.state.*;
import exp.fsm.*;

abstract Spaceship(Entity) to Entity {
	public function new(x, y) {
		this = new Entity();
		
		var left = #if openfl openfl.ui.Keyboard.LEFT #elseif luxe luxe.Input.Key.left #end;
		var right = #if openfl openfl.ui.Keyboard.RIGHT #elseif luxe luxe.Input.Key.right #end;
		var up = #if openfl openfl.ui.Keyboard.UP #elseif luxe luxe.Input.Key.up #end;
		var space = #if openfl openfl.ui.Keyboard.SPACE #elseif luxe luxe.Input.Key.space #end;
		
		var view = new graphic.SpaceshipDeathView();
		
		var fsm = StateMachine.create([
			new EntityState('playing', ['destroyed'], this, [
				new Motion(0, 0, 0, 15),
				new MotionControls(left, right, up, 100, 3),
				new Display(new graphic.SpaceshipView()),
				new Gun(8, 0, 0.3, 2),
				new GunControls(space),
				new Collision(1, [0], 9),
			]),
			new EntityState('destroyed', ['playing'], this, [
				new Display(view),
				new Animation(view),
				new Death(2),
			]),
		]);
		
		this.add(new component.Spaceship(fsm));
		this.add(new Position(x, y, 0));
		
	}
}