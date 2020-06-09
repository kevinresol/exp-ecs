package entity;

import component.*;
import exp.ecs.entity.*;
import exp.ecs.component.e2d.*;

abstract Bullet(Entity) to Entity {
	public function new(gun:Gun, transform:Transform) {
		this = new Entity();
		
		var cos = transform.a;
		var sin = transform.b;
		
		this.add(new component.Bullet());
		this.add(new Lifespan(gun.bulletLifeTime));
		this.add(new Transform(1, 0, 0, 1, cos * gun.offset.x - sin * gun.offset.y + transform.tx, sin * gun.offset.x + cos * gun.offset.y + transform.ty));
		this.add(new Motion(cos * 150, sin * 150, 0, 0));
		this.add(new Collision(2, [0], 0));
		this.add(new Display(new graphic.BulletView()));
	}
}