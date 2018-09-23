package ;

import ecs.*;
import ecs.entity.*;
import ecs.component.*;
import ecs.node.*;
import component.*;
import node.*;
import system.*;
import haxe.*;

import tink.unit.*;
import tink.testrunner.*;

using tink.CoreApi;

class RunTests {
	static function main() {
		Runner.run(TestBatch.make([
			new EngineTest(),
			new StateMachineTest(),
			new NodeListTest(),
		])).handle(Runner.exit);
	}
}

@:asserts
class EngineTest {
	public function new() {}
	
	public function addEntity() {
		var engine = new Engine();
		var entity = new Entity();
		
		var added = 0;
		engine.entityAdded.handle(function(entity) added++);
		engine.addEntity(entity);
		
		asserts.assert(added == 1);
		return asserts.done();
	}
	
	public function reAddEntity() {
		var engine = new Engine();
		var entity1 = new Entity();
		var entity2 = new Entity();
		
		var added = 0;
		engine.entityAdded.handle(function(entity) added++);
		engine.addEntity(entity1);
		engine.addEntity(entity2);
		asserts.assert(added == 2);
		asserts.assert(engine.entities[0] == entity1, 'engine.entities[0] == entity1');
		asserts.assert(engine.entities[1] == entity2, 'engine.entities[1] == entity2');
		
		engine.addEntity(entity1);
		asserts.assert(added == 3);
		asserts.assert(engine.entities[0] == entity2, 'engine.entities[0] == entity2');
		asserts.assert(engine.entities[1] == entity1, 'engine.entities[1] == entity1');
		
		return asserts.done();
	}
	
}

@:asserts
class StateMachineTest {
	public function new() {}
	
	public function fsm() {
		var entity = new Entity();
		var fsm = new EntityStateMachine(entity);
		var forward = new EntityState();
		var forwardVelocity = new Velocity(1, 0);
		forward.add(Velocity, forwardVelocity.asProvider('forward'));
		
		var backward = new EntityState();
		var backwardVelocity = new Velocity(-1, 0);
		backward.add(Velocity, backwardVelocity.asProvider('backward'));
		
		fsm.add('forward', forward);
		fsm.add('backward', backward);
		asserts.assert(entity.get(Velocity) == null, 'entity.get(Velocity) == null');
		
		fsm.change('forward');
		asserts.assert(entity.get(Velocity) == forwardVelocity, 'entity.get(Velocity) == forwardVelocity');
		
		fsm.change('backward');
		asserts.assert(entity.get(Velocity) == backwardVelocity, 'entity.get(Velocity) == backwardVelocity');
		
		return asserts.done();
	}
	
	inline function equals<T>(v1:T, v2:T)
		return v1 == v2;
}

@:asserts
class NodeListTest {
	public function new() {}
	
	@:variant('Add entity to engine before creating the node list'(true))
	@:variant('Add entity to engine after creating the node list'(false))
	public function add(lateAdd) {
		Callback.defer(function() {
			
			var engine = new Engine();
			var entity = new Entity();
			
			var added = 0, removed = 0;
			
			if(!lateAdd) engine.addEntity(entity);
			
			var list = engine.getNodeList(MovementNode);
			list.nodeAdded.handle(function(_) added++);
			list.nodeRemoved.handle(function(_) removed++);
			
			if(lateAdd) engine.addEntity(entity);
			
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
			
			asserts.done();
		});
		return asserts;
	}
}

typedef MovementNode = Node<Position, Velocity>;