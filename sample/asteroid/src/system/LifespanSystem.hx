package system;

import component.*;
import exp.ecs.node.*;
import exp.ecs.system.*;

using tink.CoreApi;

class LifespanSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<Lifespan>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			node.lifespan.lifespan -= dt;
			if(node.lifespan.lifespan < 0)
				engine.entities.remove(node.entity);
		}
	}
}