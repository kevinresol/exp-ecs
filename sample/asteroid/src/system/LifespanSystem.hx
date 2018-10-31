package system;

import component.*;
import ecs.node.*;
import ecs.system.*;

using tink.CoreApi;

class LifespanSystem<Event:EnumValue> extends System<Event> {
	@:nodes var nodes:Node<Lifespan>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			node.lifespan.lifespan -= dt;
			if(node.lifespan.lifespan < 0)
				engine.entities.remove(node.entity);
		}
	}
}