package system;

import component.*;
import ecs.Node;
import ecs.System;

using tink.CoreApi;

private typedef LifetimeNode = Node<Lifetime>;
class LifetimeSystem extends NodeListSystem<LifetimeNode> {
	override function updateNode(node:LifetimeNode, dt:Float) {
		node.lifetime.lifetime -= dt;
		if(node.lifetime.lifetime < 0)
			engine.removeEntity(node.entity);
	}
}