package;

import Types;
import exp.ecs.*;
import exp.ecs.entity.*;
import exp.ecs.state.*;
import exp.fsm.*;


@:asserts
class EngineTest extends Base {
	public function addEntity() {
		var engine = new Engine();
		var entity = new Entity();
		
		var added = 0;
		engine.entities.added.handle(function(entity) added++);
		engine.entities.add(entity);
		
		asserts.assert(added == 1);
		
		engine.destroy();
		return asserts.done();
	}
	
	public function reAddEntity() {
		var engine = new Engine();
		var entity1 = new Entity();
		var entity2 = new Entity();
		
		var added = 0;
		engine.entities.added.handle(function(entity) added++);
		engine.entities.add(entity1);
		engine.entities.add(entity2);
		asserts.assert(added == 2);
		var entities = [for(e in engine.entities) e];
		asserts.assert(entities[0] == entity1, 'engine.entities[0] == entity1');
		asserts.assert(entities[1] == entity2, 'engine.entities[1] == entity2');
		
		engine.entities.add(entity1);
		asserts.assert(added == 3);
		var entities = [for(e in engine.entities) e];
		asserts.assert(entities[0] == entity2, 'engine.entities[0] == entity2');
		asserts.assert(entities[1] == entity1, 'engine.entities[1] == entity1');
		
		engine.destroy();
		return asserts.done();
	}
	
	public function addSystem() {
		
		var engine = new Engine();
		var fsm = StateMachine.create([
			new EngineState('foo', [], engine, [{system: new MovementSystem(), before: MovementSystem}]),
		]);
		return asserts.done();
	}
	
}