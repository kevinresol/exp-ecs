package system;

import component.*;
import ecs.System;
import ecs.Node;
import node.*;

using tink.CoreApi;

class GameSystem extends NodeListSystem<{nodes:Node<Position, State>}> {
	
	override function update(dt:Float) {
		for(node in nodes) {
			if(node.position.x > 2) node.state.fsm.change('backward');
			if(node.position.x < 0) node.state.fsm.change('forward');
		}
	}
}