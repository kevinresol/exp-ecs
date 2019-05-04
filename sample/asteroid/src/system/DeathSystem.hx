package system;

import component.*;
import exp.ecs.node.*;
import exp.ecs.system.*;

using tink.CoreApi;

class DeathSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<Death>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			node.death.countdown -= dt;
			if(node.death.countdown < 0) engine.entities.remove(node.entity);
		}
	}
}