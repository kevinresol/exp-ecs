package system;

import component.*;
import ecs.Node;
import ecs.System;

using tink.CoreApi;

class AnimationSystem extends NodeListSystem<{nodes:Node<Animation>}> {
	override function update(dt:Float) {
		for(node in nodes)
			node.animation.anime.animate(dt);
	}
}