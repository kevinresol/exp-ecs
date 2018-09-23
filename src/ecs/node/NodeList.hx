package ecs.node;

import ecs.entity.*;
using tink.CoreApi;

// TODO: find something else to back a NodeList, because ObjectMap is pretty slow on iterating
class NodeList<T:NodeBase> {
	public var id(default, null):Int;
	public var nodeAdded(default, null):Signal<T>;
	public var nodeRemoved(default, null):Signal<T>;
	public var empty(get, never):Bool;
	public var head(get, never):T;
	
	var nodeAddedTrigger:SignalTrigger<T>;
	var nodeRemovedTrigger:SignalTrigger<T>;
	var nodes:Map<Entity, T>;
	var factory:Entity->T;
	var name:String;
	
	static var ids:Int = 0;
	
	public function new(factory, ?name) {
		id == ++ids;
		nodes = new Map();
		nodeAdded = nodeAddedTrigger = Signal.trigger();
		nodeRemoved = nodeRemovedTrigger = Signal.trigger();
		this.factory = factory;
		this.name = name;
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
	inline function get_empty() return !iterator().hasNext();
	inline function get_head() {
		var iter = iterator();
		return iter.hasNext() ? iter.next() : null;
	}
	
	public function toString():String {
		return name == null ? 'NodeList#$id' : name;
	}
}
