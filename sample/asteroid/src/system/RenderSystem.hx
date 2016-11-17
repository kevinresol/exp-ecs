package system;

import ecs.Engine;
import ecs.Node;
import ecs.System;
import node.Nodes;
import util.*;

using tink.CoreApi;

class RenderSystem extends NodeListSystem<RenderNode> {
	var container:openfl.display.DisplayObjectContainer;
	var listeners:Array<CallbackLink>;
	
	public function new(container) {
		super();
		this.container = container;
	}
	
	override function onAdded(engine:Engine) {
		super.onAdded(engine);
		for(node in nodes) addToDisplay(node);
		listeners = [
			nodes.nodeAdded.handle(addToDisplay),
			nodes.nodeRemoved.handle(removeFromDisplay),
		];
	}
	
	override function onRemoved(engine:Engine) {
		while(listeners.length > 0) listeners.pop().dissolve();
		nodes = null;
	}
	
	function addToDisplay(node:RenderNode) {
		container.addChild(node.display.object);
	}
	function removeFromDisplay(node:RenderNode) {
		container.removeChild(node.display.object);
	}
	
	override function updateNode(node:RenderNode, dt:Float) {
		var display = node.display.object;
		var position = node.position;
		display.x = position.position.x;
		display.y = position.position.y;
		display.rotation = position.rotation * 180 / Math.PI;
	}
}