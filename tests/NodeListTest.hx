package;

import Types;
import exp.ecs.Engine;
import exp.ecs.entity.Entity;

using StringTools;

@:asserts
class NodeListTest {
	public function new() {}
	
	@:variant('Add entity to engine before creating the node list'(true))
	@:variant('Add entity to engine after creating the node list'(false))
	public function add(lateAdd) {
		return asserts.defer(function() {
			
			var engine = new Engine();
			var entity = new Entity();
			
			var added = 0, removed = 0;
			
			if(!lateAdd) engine.entities.add(entity);
			
			var list = engine.getNodeList(MovementNode, MovementNode.createNodeList);
			list.nodeAdded.handle(function(_) added++);
			list.nodeRemoved.handle(function(_) removed++);
			
			if(lateAdd) engine.entities.add(entity);
			
			asserts.assert(list.toString() == 'TrackingNodeList#Position,Velocity');
			asserts.assert(added == 0);
			asserts.assert(removed == 0);
			var velocity = new Velocity(0, 0);
			var position = new Position(0, 0);
			
			entity.add(velocity);
			asserts.assert(list.length == 0);
			asserts.assert(added == 0);
			asserts.assert(removed == 0);
			
			entity.add(position);
			asserts.assert(list.length == 1);
			asserts.assert(added == 1);
			asserts.assert(removed == 0);
			
			entity.remove(velocity);
			asserts.assert(list.length == 0);
			asserts.assert(added == 1);
			asserts.assert(removed == 1);
			
			entity.add(velocity);
			asserts.assert(list.length == 1);
			asserts.assert(added == 2);
			asserts.assert(removed == 1);
			
			engine.destroy();
			asserts.done();
		});
	}
	
	@:variant('Add entity to engine before creating the node list'(true))
	@:variant('Add entity to engine after creating the node list'(false))
	public function optional(lateAdd) {
		return asserts.defer(function() {
			var engine = new Engine();
			var entity = new Entity();
			
			var added = 0, removed = 0;
			
			if(!lateAdd) engine.entities.add(entity);
			
			var list = engine.getNodeList(OptionalNode, OptionalNode.createNodeList);
			list.nodeAdded.handle(function(_) added++);
			list.nodeRemoved.handle(function(_) removed++);
			
			if(lateAdd) engine.entities.add(entity);
			
			asserts.assert(list.toString() == 'TrackingNodeList#Position,?Velocity');
			asserts.assert(added == 0);
			var velocity = new Velocity(0, 0);
			var position = new Position(0, 0);
			
			entity.add(position);
			asserts.assert(list.length == 1);
			asserts.assert(added == 1);
			asserts.assert(removed == 0);
			for(node in list) {
				asserts.assert(node.toString().startsWith('TrackingNode#Position,?Velocity'));
				asserts.assert(node.position != null, 'node.position != null');
				asserts.assert(node.velocity == null, 'node.velocity == null');
			}
			
			entity.add(velocity);
			asserts.assert(list.length == 1);
			asserts.assert(added == 1);
			asserts.assert(removed == 0);
			for(node in list) {
				asserts.assert(node.position != null, 'node.position != null');
				asserts.assert(node.velocity != null, 'node.velocity != null');
			}
			
			entity.remove(velocity);
			asserts.assert(list.length == 1);
			asserts.assert(added == 1);
			asserts.assert(removed == 0);
			for(node in list) {
				asserts.assert(node.position != null, 'node.position != null');
				asserts.assert(node.velocity == null, 'node.velocity == null');
			}
			
			entity.remove(position);
			asserts.assert(list.length == 0);
			asserts.assert(added == 1);
			asserts.assert(removed == 1);
			
			engine.destroy();
			asserts.done();
		});
	}
}