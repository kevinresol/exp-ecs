package exp.ecs.system.e2d;

import exp.ecs.Engine;
import exp.ecs.node.*;
import exp.ecs.system.*;
import exp.ecs.component.e2d.*;

using tink.CoreApi;

class VisualSystem<Event> extends System<Event> {
	
	@:nodes var nodes:Node<Transform, Visual>;
	
	var listeners:CallbackLink;
	
	var container:openfl.display.DisplayObjectContainer;
	
	public function new(container) {
		super();
		this.container = container;
	}
	
	override function onAdded(engine:Engine<Event>) {
		super.onAdded(engine);
		for(node in nodes) addToDisplay(node);
		listeners = [
			nodes.nodeAdded.handle(addToDisplay),
			nodes.nodeRemoved.handle(removeFromDisplay),
		];
	}
	
	override function onRemoved(engine:Engine<Event>) {
		for(node in nodes) removeFromDisplay(node);
		super.onRemoved(engine);
		listeners.dissolve();
		listeners = null;
	}
	
	function addToDisplay(node:Node<Transform, Visual>) {
		container.addChild(node.visual.object);
	}
	
	function removeFromDisplay(node:Node<Transform, Visual>) {
		container.removeChild(node.visual.object);
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			node.visual.setTransform(node.transform);
		}
	}
}