package ecs.node;

import ecs.entity.*;
import ecs.util.*;
using tink.CoreApi;
using Lambda;

class NodeList<T:NodeBase> {
	public var length(get, never):Int;
	public var empty(get, never):Bool;
	public var head(get, never):T;
	public var id(default, null):Int;
	public var nodeAdded(default, null):Signal<T>;
	public var nodeRemoved(default, null):Signal<T>;
	
	var nodeAddedTrigger:SignalTrigger<T>;
	var nodeRemovedTrigger:SignalTrigger<T>;
	var entities:Array<Int>;
	var nodes:Array<T>;
	var factory:Entity->T;
	var name:String;
	
	static var ids:Int = 0;
	
	public function new(factory, ?name) {
		entities = [];
		nodes = [];
		id = ++ids;
		nodeAdded = nodeAddedTrigger = Signal.trigger();
		nodeRemoved = nodeRemovedTrigger = Signal.trigger();
		this.factory = factory;
		this.name = name;
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
					node.destroy();
					true;
			}
	}
	
	public function destroy() {
		for(node in nodes) node.destroy();
		nodes = null;
		entities = null;
		
		// TODO: destroy signals
	}
	
	public inline function iterator() return new ConstArrayIterator(nodes);
	
	inline function get_length() return nodes.length;
	inline function get_empty() return nodes.length == 0;
	inline function get_head() return nodes[0];
	
	public function toString():String {
		return name == null ? 'NodeList#$id' : name;
	}
}

