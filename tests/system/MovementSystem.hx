package system;

import component.*;
import ecs.node.*;
import ecs.system.*;

using tink.CoreApi;


class MovementSystem extends System<{nodes:Node<Position, Velocity>}> {
	
	override function update(dt:Float) {
		for(node in nodes) {
			node.position.x += node.velocity.x * dt;
			trace(node.position.x);
		}
	}
}