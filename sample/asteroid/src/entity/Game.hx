package entity;

import component.*;
import ecs.*;
import ecs.EntityStateMachine;

abstract Game(Entity) to Entity {
	public function new() {
		var e = new Entity();
		e.add(new component.Game());
		this = e;
	}
}