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
		
		engine.entities.add(entity);
		engine.systems.add(new MovementSystem());
		engine.systems.add(new RenderSystem());
		engine.systems.add(new CustomSystem());
		
		new Timer(16).run = function() engine.update(16 / 1000);
	}
}

class MovementSystem extends System {
	@:nodes var nodes:Node<Position, Velocity>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			node.position.x += node.velocity.x * dt;
			node.position.y += node.velocity.y * dt;
		}
	}
}

class RenderSystem extends System {
	@:nodes var nodes:Node<Position>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			trace('${node.entity} @ ${node.position.x}, ${node.position.y}');
		}
	}
}

class CustomSystem extends System {
	var nodes:NodeList<CustomNode>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			$type(node); // CustomNode
			trace(node.entity.get(Position));
		}
	}
	
	override function onAdded(engine) {
		super.onAdded(engine);
		nodes = engine.getNodeList(CustomNode, engine -> new TrackingNodeList(engine, CustomNode.new, entity -> entity.has(Position)));
	}
	
	override function onRemoved(engine) {
		super.onRemoved(engine);
		nodes = null;
	}
}

class CustomNode extends NodeBase {
	public function new(entity) {
		this.entity = entity;
	}
}