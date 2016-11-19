package system;

import component.*;
import ecs.node.*;
import ecs.system.*;

using tink.CoreApi;

class DeathSystem extends NodeListSystem<{nodes:Node<Death>}> {
	override function update(dt:Float) {
		for(node in nodes) {
			node.death.countdown -= dt;
			if(node.death.countdown < 0) engine.removeEntity(node.entity);
		}
	}
}