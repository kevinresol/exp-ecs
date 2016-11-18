package system;

import component.*;
import ecs.Node;
import ecs.System;

using tink.CoreApi;

private typedef BulletNode = Node<Bullet>;
class BulletSystem extends NodeListSystem<BulletNode> {
	override function updateNode(node:BulletNode, dt:Float) {
		node.bullet.lifetime -= dt;
		if(node.bullet.lifetime < 0)
			engine.removeEntity(node.entity);
	}
}