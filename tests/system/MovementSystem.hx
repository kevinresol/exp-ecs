package system;

import component.*;
import ecs.Node;
import ecs.System;

using tink.CoreApi;


class MovementSystem extends NodeListSystem<{nodes:Node<Position, Velocity>}> {
	
	override function update(dt:Float) {
		for(node in nodes) {
			node.position.x += node.velocity.x * dt;
			trace(node.position.x);
		}
	}
}