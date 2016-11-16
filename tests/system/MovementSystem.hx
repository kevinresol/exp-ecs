package system;

import ecs.Engine;
import ecs.Node;
import ecs.System;
import component.*;

using tink.CoreApi;

typedef MovementNode = Node<Position>;

class MovementSystem extends NodeListSystem<MovementNode> {
	
	override function updateNode(node:MovementNode, dt:Float) {
		trace(node.position.x);
		node.position.x ++;
	}
}