package entity;

import component.*;
import ecs.*;
import ecs.EntityStateMachine;

abstract Asteroid(Entity) to Entity {
	public function new(radius, x, y) {
		this = new Entity();
		
		this.add(new component.Asteroid());
		this.add(new Position(x, y, 0));
		this.add(new Collision(radius));
		this.add(new Motion((Math.random() - 0.5) * 4 * (50 - radius), (Math.random() - 0.5) * 4 * (50 - radius), Math.random() * 2 - 1, 0));
		this.add(new Display(new graphic.AsteroidView(radius)));
	}
}