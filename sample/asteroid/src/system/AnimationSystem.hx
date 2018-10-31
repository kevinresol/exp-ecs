package system;

import component.*;
import ecs.node.*;
import ecs.system.*;

using tink.CoreApi;

class AnimationSystem<Event:EnumValue> extends System<Event> {
	@:nodes var nodes:Node<Animation>;
	override function update(dt:Float) {
		for(node in nodes)
			node.animation.anime.animate(dt);
	}
}