package;

import ecs.*;
import ecs.node.*;
import ecs.entity.*;
import ecs.system.*;
import component.*;
import haxe.Timer;

class Playground {
	static function main() {
		var engine = new Engine();
		var entity = new Entity();
		entity.add(new Velocity(1, 0));
		entity.add(new Position(0, 0));
		
		engine.addEntity(entity);
		engine.addSystem(new MovementSystem());
		engine.addSystem(new RenderSystem());
		
		new Timer(16).run = function() engine.update(16 / 1000);
	}
}

class MovementSystem extends NodeListSystem {
	@:nodes var nodes:Node<Position, Velocity>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			node.position.x += node.velocity.x * dt;
			node.position.y += node.velocity.y * dt;
		}
	}
}

class RenderSystem extends NodeListSystem {
	@:nodes var nodes:Node<Position>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			trace('${node.entity} @ ${node.position.x}, ${node.position.y}');
		}
	}
}