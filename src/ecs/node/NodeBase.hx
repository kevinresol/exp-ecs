package ecs.node;

import ecs.entity.*;

class NodeBase {
	public var entity(default, null):Entity;
	
	var name:String = 'NodeBase';
	
	public function destroy() {
		entity = null;
	}
	
	public function toString() {
		return '$name($entity)';
	}
}