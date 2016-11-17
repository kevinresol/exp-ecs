package ecs;

import ecs.Node;
using tink.CoreApi;

interface System {
	function update(dt:Float):Void;
	function onAdded(engine:Engine):Void;
	function onRemoved(engine:Engine):Void;
	function toString():String;
}

#if !macro @:genericBuild(ecs.Macro.buildNodeListSystem()) #end
class NodeListSystem<T> {}

class NodeListSystemBase<T> implements System {
	
	var nodes:NodeList<T>;
	
	public function new() {
		
	}
	
	public function onAdded(engine:Engine) {
		
	}
	
	public function onRemoved(engine:Engine) {
		nodes = null;
	}
	
	public function update(dt:Float) {
		for(node in nodes) updateNode(node, dt);
	}
	
	function updateNode(node:T, dt:Float) {
		
	}
	
	public function toString()
		return Type.getClassName(Type.getClass(this));
}