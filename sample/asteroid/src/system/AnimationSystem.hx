package system;

import component.*;
import exp.ecs.node.*;
import exp.ecs.system.*;

using tink.CoreApi;

class AnimationSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<Animation>;
	override function update(dt:Float) {
		for(node in nodes)
			node.animation.anime.animate(dt);
	}
}