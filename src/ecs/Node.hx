package ecs;

using tink.CoreApi;

#if !macro @:genericBuild(ecs.Macro.buildNode()) #end
class Node<Rest> {}

// TODO: find something else to back a NodeList, because ObjectMap is pretty slow on iterating
class NodeList<T:NodeBase> {
	public var empty(get, never):Bool;
	public var head(get, never):T;
	public var nodeAdded:Signal<T>;
	public var nodeRemoved:Signal<T>;
	
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

interface NodeBase {
	var entity(default, null):Entity;
}

abstract NodeType(String) to String {
	inline function new(v:String)
		this = v;
	
	@:from
	public static inline function ofClass(v:Class<NodeBase>):NodeType
		return new NodeType(Type.getClassName(v));
		
	@:from
	public static inline function ofInstance(v:NodeBase):NodeType
		return ofClass(Type.getClass(v));
		
	@:to
	public inline function toClass():Class<NodeBase>
		return cast Type.resolveClass(this);
}