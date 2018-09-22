package ecs.node;

import ecs.entity.*;
using tink.CoreApi;

// TODO: find something else to back a NodeList, because ObjectMap is pretty slow on iterating
class NodeList<T:NodeBase> {
	public var empty(get, never):Bool;
	public var head(get, never):T;
	public var nodeAdded(default, null):Signal<T>;
	public var nodeRemoved(default, null):Signal<T>;
	
	var nodeAddedTrigger:SignalTrigger<T>;
	var nodeRemovedTrigger:SignalTrigger<T>;
	var nodes:Map<Entity, T>;
	var factory:Entity->T;
	
	public function new(factory) {
		nodes = new Map();
		nodeAdded = nodeAddedTrigger = Signal.trigger();
		nodeRemoved = nodeRemovedTrigger = Signal.trigger();
		this.factory = factory;
	}
	
	public function add(entity:Entity) {
		return 
			if(!nodes.exists(entity)) {
				var node = factory(entity);
				nodes.set(entity, node);
				nodeAddedTrigger.trigger(node);
				true;
			} else {
				false;
			}
	}
	
	public function remove(entity:Entity) {
		return 
			switch nodes.get(entity) {
				case null:
					false;
				case node: 
					nodes.remove(entity);
					nodeRemovedTrigger.trigger(node);
					true;
			}
	}
	
	
	public function destroy() {
		nodes = null;
		// TODO: destroy signals
	}
	
	public inline function iterator() return nodes.iterator();
	inline function get_empty() return Lambda.empty(nodes);
	function get_head() {
		for(node in nodes) return node;
		return null;
	}
	
	public function toString():String {
		return 'NodeList';
	}
}
