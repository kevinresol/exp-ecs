package entity;

import component.*;
import ecs.entity.*;

abstract Asteroid(Entity) to Entity {
	static var mask = [0, 1];
	public function new(radius, x, y) {
		this = new Entity();
		
		this.add(new component.Asteroid(radius));
		this.add(new Position(x, y, 0));
		this.add(new Collision(mask, radius));
		this.add(new Motion((Math.random() - 0.5) * 4 * (50 - radius), (Math.random() - 0.5) * 4 * (50 - radius), Math.random() * 2 - 1, 0));
		this.add(new Display(new graphic.AsteroidView(radius)));
	}
}