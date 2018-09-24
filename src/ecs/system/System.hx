package ecs.system;

import ecs.*;

#if !macro @:autoBuild(ecs.util.Macro.buildSystem()) #end
class System implements SystemBase {
	var engine:Engine;
	
	public function new() {}
	
	public function update(dt:Float) {}
	
	public function onAdded(engine:Engine) {
		this.engine = engine;
		setNodeLists(engine);
	}
	
	public function onRemoved(engine:Engine) {
		this.engine = null;
		unsetNodeLists();
	}
	
	function setNodeLists(engine:Engine) {
		throw 'abstract';
	}
	
	function unsetNodeLists() {
		throw 'abstract';
	}
}
