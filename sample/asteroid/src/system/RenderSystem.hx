package system;

import component.*;
import ecs.Engine;
import ecs.Node;
import ecs.System;

using tink.CoreApi;

class RenderSystem extends NodeListSystem<{nodes:Node<Position, Display>}> {
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
		super.onRemoved(engine);
		while(listeners.length > 0) listeners.pop().dissolve();
	}
	
	function addToDisplay(node) {
		container.addChild(node.display.object);
	}
	function removeFromDisplay(node) {
		container.removeChild(node.display.object);
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var display = node.display.object;
			var position = node.position;
			display.x = position.position.x;
			display.y = position.position.y;
			display.rotation = position.rotation * 180 / Math.PI;
		}
	}
}