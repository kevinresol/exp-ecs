package ecs.node;

import ecs.node.Node;
import ecs.entity.*;
using tink.CoreApi;


#if !macro @:genericBuild(ecs.util.Macro.buildNodeList()) #end
class NodeList<Rest> {}

// TODO: find something else to back a NodeList, because ObjectMap is pretty slow on iterating
class NodeListBase<T:NodeBase> {
	public var empty(get, never):Bool;
	public var head(get, never):T;
	public var nodeAdded(default, null):Signal<T>;
	public var nodeRemoved(default, null):Signal<T>;
	
	var nodeAddedTrigger:SignalTrigger<T>;
	var nodeRemovedTrigger:SignalTrigger<T>;
	var nodes:Map<Entity, T>;
	
	public function new() {
		nodes = new Map();
		nodeAdded = nodeAddedTrigger = Signal.trigger();
		nodeRemoved = nodeRemovedTrigger = Signal.trigger();
	}
	
	public function add(node:T) {
		if(!nodes.exists(node.entity)) {
			nodes.set(node.entity, node);
			nodeAddedTrigger.trigger(node);
		}
	}
	
	public function removeEntity(entity:Entity) {
		switch nodes.get(entity) {
			case null: // do nothing
			case node: 
				nodes.remove(entity);
				nodeRemovedTrigger.trigger(node);
		}
	}
	
	public inline function iterator() return nodes.iterator();
	inline function get_empty() return Lambda.empty(nodes);
	function get_head() {
		for(node in nodes) return node;
		return null;
	}
}
