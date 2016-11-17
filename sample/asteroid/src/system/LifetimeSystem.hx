package system;

import ecs.Engine;
import ecs.Node;
import ecs.System;
import node.Nodes;
import util.*;

using tink.CoreApi;

class LifetimeSystem extends NodeListSystem<LifetimeNode> {
	override function updateNode(node:LifetimeNode, dt:Float) {
		node.lifetime.lifetime -= dt;
		if(node.lifetime.lifetime < 0)
			engine.removeEntity(node.entity);
	}
}