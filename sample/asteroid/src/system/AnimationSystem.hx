package system;

import component.*;
import ecs.Node;
import ecs.System;

using tink.CoreApi;

private typedef AnimationNode = Node<Animation>;
class AnimationSystem extends NodeListSystem<AnimationNode> {
	override function updateNode(node:AnimationNode, dt:Float) {
		node.animation.anime.animate(dt);
	}
}