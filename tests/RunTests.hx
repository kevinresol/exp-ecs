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

class RunTests {
	static function main() {
		Runner.run(TestBatch.make([
			new EngineTest(),
			new StateMachineTest(),
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