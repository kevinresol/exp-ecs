package entity;

import openfl.display.*;
import component.*;
import ecs.*;
import ecs.EntityStateMachine;

abstract Bullet(Entity) to Entity {
	public function new(gun:Gun, position:Position) {
		this = new Entity();
		
		var cos = Math.cos(position.rotation);
		var sin = Math.sin(position.rotation);
		var bm = new Bitmap(new BitmapData(6, 6, false, 0));
		bm.x = bm.y = -3;
		var sprite = new Sprite();
		sprite.addChild(bm);
		
		this.add(new Lifetime(gun.bulletLifeTime));
		this.add(new Position(cos * gun.offset.x - sin * gun.offset.y + position.position.x, sin * gun.offset.x + cos * gun.offset.y + position.position.y, 0));
		this.add(new Motion(cos * 150, sin * 150, 0, 0));
		this.add(new Display(sprite));
	}
}