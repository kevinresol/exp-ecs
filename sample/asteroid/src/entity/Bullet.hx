package entity;

import component.*;
import ecs.entity.*;

abstract Bullet(Entity) to Entity {
	static var mask = [1];
	public function new(gun:Gun, position:Position) {
		this = new Entity();
		
		var cos = Math.cos(position.rotation);
		var sin = Math.sin(position.rotation);
		
		this.add(new component.Bullet());
		this.add(new Lifespan(gun.bulletLifeTime));
		this.add(new Position(cos * gun.offset.x - sin * gun.offset.y + position.position.x, sin * gun.offset.x + cos * gun.offset.y + position.position.y, 0));
		this.add(new Motion(cos * 150, sin * 150, 0, 0));
		this.add(new Collision(mask, 0));
		this.add(new Display(new graphic.BulletView()));
	}
}