package ecs.node;

import ecs.entity.*;
using tink.CoreApi;
using Lambda;

// TODO: find something else to back a NodeList, because ObjectMap is pretty slow on iterating
class NodeList<T:NodeBase> {
	public var length(get, never):Int;
	public var empty(get, never):Bool;
	public var head(get, never):T;
	public var nodeAdded(default, null):Signal<T>;
	public var nodeRemoved(default, null):Signal<T>;
	
	var nodeAddedTrigger:SignalTrigger<T>;
	var nodeRemovedTrigger:SignalTrigger<T>;
	var entities:Array<Int>;
	var nodes:Array<T>;
	var factory:Entity->T;
	
	public function new(factory) {
		entities = [];
		nodes = [];
		nodeAdded = nodeAddedTrigger = Signal.trigger();
		nodeRemoved = nodeRemovedTrigger = Signal.trigger();
		this.factory = factory;
	}
	
	public function add(entity:Entity) {
		return 
			if(entities.indexOf(entity.id) == -1) {
				var node = factory(entity);
				entities.push(entity.id);
				nodes.push(node);
				nodeAddedTrigger.trigger(node);
				true;
			} else {
				false;
			}
	}
	
	public function remove(entity:Entity) {
		return 
			switch entities.indexOf(entity.id) {
				case -1:
					false;
				case i:
					var node = nodes[i];
					nodes.splice(i, 1);
					entities.splice(i, 1);
					nodeRemovedTrigger.trigger(node);
					true;
			}
	}
	
	
	public function destroy() {
		entities = null;
		nodes = null;
		// TODO: destroy signals
	}
	
	public inline function iterator() return new ConstArrayIterator(nodes);
	
	inline function get_length() return nodes.length;
	inline function get_empty() return nodes.length == 0;
	inline function get_head() return nodes[0];
	
	public function toString():String {
		return 'NodeList';
	}
}

class ConstArrayIterator<T> {

	var cur:Int;
	var max:Int;
	var array:Array<T>;

	public inline function new(arr:Array<T>) {
		cur = 0;
		max = arr.length;
		array = arr;
	}

	public inline function hasNext():Bool {
		return cur != max;
	}

	public inline function next():T {
		return array[cur++];
	}
}