package system;

import component.*;
import exp.ecs.Engine;
import exp.ecs.node.*;
import exp.ecs.system.*;
import exp.ecs.component.e2d.*;

using tink.CoreApi;

class RenderSystem<Event> extends System<Event> {
	
	@:nodes var nodes:Node<Transform, Display>;
	
	var listeners:CallbackLink;
	
	#if openfl
	var container:openfl.display.DisplayObjectContainer;
	
	public function new(container) {
		super();
		this.container = container;
	}
	#end
	
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
	
	function addToDisplay(node:Node<Transform, Display>) {
		#if openfl
		container.addChild(node.display.object);
		#elseif luxe
		node.display.object.visible = true;
		#end
	}
	
	function removeFromDisplay(node:Node<Transform, Display>) {
		#if openfl
		container.removeChild(node.display.object);
		#elseif luxe
		node.display.object.destroy();
		#end
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var display = node.display.object;
			var transform = node.transform;
			#if openfl
			@:privateAccess display.transform.__setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			#elseif luxe
			display.pos.x = transform.transform.x;
			display.pos.y = transform.transform.y;
			display.rotation_z = transform.rotation * 180 / Math.PI;
			#end
		}
	}
}