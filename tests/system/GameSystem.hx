package system;

import ecs.Engine;
import ecs.Node;
import ecs.System;
import node.*;
import component.State;

using tink.CoreApi;

class GameSystem extends NodeListSystem<GameNode> {
	
	override function updateNode(node:GameNode, dt:Float) {
		if(node.position.x > 2) node.state.fsm.change(Backward);
		if(node.position.x <= 0) node.state.fsm.change(Forward);
	}
}