package ;

import ecs.*;
import component.*;
import node.*;
import system.*;
import haxe.*;

class RunTests {

	static function main() {
		var engine = new Engine();
		engine.addSystem(new MovementSystem());
		
		var entity = new Entity();
		entity.add(new Position(0, 0));
		entity.add(new Velocity(1, 0));
		
		engine.addEntity(entity);
		
		engine.getNodeList(MovementNode);
		
		var timer = new Timer(16);
		timer.run = function() engine.update(16/1000);
	}
	
	
}
