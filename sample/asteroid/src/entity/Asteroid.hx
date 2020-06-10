package entity;

import component.*;
import exp.ecs.entity.*;
import exp.ecs.component.e2d.*;

abstract Asteroid(Entity) to Entity {
	public function new(radius, x, y) {
		this = new Entity();
		
		this.add(new component.Asteroid(radius));
		this.add(new Transform(1, 0, 0, 1, x, y));
		this.add(new Collision(0, [1, 2], radius));
		this.add(new Motion((Math.random() - 0.5) * 4 * (50 - radius), (Math.random() - 0.5) * 4 * (50 - radius), Math.random() * 2 - 1, 0));
		this.add(new Visual(new graphic.AsteroidView(radius)));
	}
}