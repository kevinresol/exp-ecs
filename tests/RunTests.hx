package ;

import ecs.*;
import ecs.EntityStateMachine;
import ecs.Component;
import component.*;
import node.*;
import system.*;
import haxe.*;

class RunTests {

	static function main() {
		var engine = new Engine();
		engine.addSystem(new GameSystem());
		engine.addSystem(new MovementSystem());
		
		var entity = new Entity();
		
		var fsm = new EntityStateMachine(entity);
		var forward = new EntityState();
		forward.add(Velocity, new ComponentInstanceProvider(new Velocity(1, 0), 'forward'));
		var backward = new EntityState();
		backward.add(Velocity, new ComponentInstanceProvider(new Velocity(-1, 0), 'backward'));
		fsm.add('forward', forward);
		fsm.add('backward', backward);
		fsm.change('forward');
		
		entity.add(new Position(0, 0));
		entity.add(new State(fsm));
		
		engine.addEntity(entity);
		
		var timer = new Timer(33);
		timer.run = function() engine.update(33/1000);
		
		trace(engine);
	}
	
	
}
