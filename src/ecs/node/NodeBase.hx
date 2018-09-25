package ecs.node;

import ecs.entity.*;

class NodeBase {
	public var entity(default, null):Entity;
	
	public function destroy() {
		entity = null;
	}
}