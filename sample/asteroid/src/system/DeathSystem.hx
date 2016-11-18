package system;

import component.*;
import ecs.Node;
import ecs.System;

using tink.CoreApi;

private typedef DeathNode = Node<Death>;
class DeathSystem extends NodeListSystem<DeathNode> {
	override function updateNode(node:DeathNode, dt:Float) {
		node.death.countdown -= dt;
		if(node.death.countdown < 0) engine.removeEntity(node.entity);
	}
}