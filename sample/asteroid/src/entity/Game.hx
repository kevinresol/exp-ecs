package entity;

import component.*;
import ecs.entity.*;

abstract Game(Entity) to Entity {
	public function new() {
		this = new Entity();
		this.add(new component.Game());
	}
}