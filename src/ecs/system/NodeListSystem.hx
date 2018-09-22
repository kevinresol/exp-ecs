package ecs.system;

import ecs.*;

#if !macro @:autoBuild(ecs.util.Macro.buildNodeListSystem()) #end
class NodeListSystem extends System {
	
	override function onAdded(engine:Engine) {
		super.onAdded(engine);
		setNodeLists(engine);
	}
	
	override function onRemoved(engine:Engine) {
		super.onRemoved(engine);
		unsetNodeLists();
	}
	
	function setNodeLists(engine:Engine) {
		throw 'abstract';
	}
	
	function unsetNodeLists() {
		throw 'abstract';
	}
}
