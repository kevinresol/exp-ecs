package ecs;

import ecs.Node;
using tink.CoreApi;

interface System {
	function update(dt:Float):Void;
	function onAdded(engine:Engine):Void;
	function onRemoved(engine:Engine):Void;
}

@:genericBuild(ecs.Macro.buildNodeListSystem())
class NodeListSystem<T> {}

class NodeListSystemBase<T> implements System {
	
	var nodes:NodeList<T>;
	var listeners:Array<CallbackLink>;
	
	public function new() {
		
	}
	
	public function onAdded(engine:Engine) {
		
	}
	
	public function onRemoved(engine:Engine) {
		nodes = null;
		while(listeners.length > 0) listeners.pop().dissolve();
	}
	
	public function update(dt:Float) {
		for(node in nodes) updateNode(node, dt);
	}
	
	function updateNode(node:T, dt:Float) {
		
	}
}