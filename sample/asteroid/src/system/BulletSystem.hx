package system;

import component.*;
import ecs.Node;
import ecs.System;

using tink.CoreApi;

private typedef BulletNode = Node<Bullet>;
class BulletSystem extends NodeListSystem<{nodes:Node<Bullet>}> {
	override function update(dt:Float) {
		for(node in nodes) {
			node.bullet.lifetime -= dt;
			if(node.bullet.lifetime < 0)
				engine.removeEntity(node.entity);
		}
	}
}