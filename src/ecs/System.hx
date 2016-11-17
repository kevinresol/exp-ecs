package ecs;

import ecs.Node;
using tink.CoreApi;

class System {
	var engine:Engine;
	
	public function new() {}
	
	public function update(dt:Float) {}
	
	public function onAdded(engine:Engine)
		this.engine = engine;
	
	public function onRemoved(engine:Engine)
		engine = null;
	
	public function toString()
		return Type.getClassName(Type.getClass(this));
}

#if !macro @:genericBuild(ecs.Macro.buildNodeListSystem()) #end
class NodeListSystem<T> {}

class NodeListSystemBase<T:NodeBase> extends System {
	
	var nodes:NodeList<T>;
	
	override function onRemoved(engine:Engine) {
		super.onRemoved(engine);
		nodes = null;
	}
	
	override function update(dt:Float)
		for(node in nodes) updateNode(node, dt);
	
	function updateNode(node:T, dt:Float) {}
}