package ecs.node;

import ecs.*;
import ecs.node.Node;
import ecs.component.*;
import ecs.entity.*;
using tink.CoreApi;


// #if !macro @:genericBuild(ecs.util.Macro.buildNodeList()) #end
class NodeList<T:NodeBase> extends NodeListBase<T> {
	var componentTypes:Array<ComponentType>;
	var factory:Entity->T;
	var engine:Engine;
	var listeners = new Map();
	
	public function new(engine, factory, componentTypes) {
		super();
		
		this.engine = engine;
		this.factory = factory;
		this.componentTypes = componentTypes;
		
		for(entity in engine.entities) {
			addEntityIfMatch(entity);
			track(entity);
		}
			
		// TODO: if we destroy a node list, we need to dissolve the handlers
		engine.entityAdded.handle(function(e) {
			addEntityIfMatch(e);
			track(e);
		});
		engine.entityRemoved.handle(function(e) {
			removeEntity(e);
			untrack(e);
		});
	}
	
	function addEntityIfMatch(entity:ecs.entity.Entity) 
		if(entity.hasAll(componentTypes))
			add(factory(entity));
			
	function removeEntityIfNoLongerMatch(entity:ecs.entity.Entity) 
		if(!entity.hasAll(componentTypes))
			removeEntity(entity);
			
	function track(entity:ecs.entity.Entity) {
		if(listeners.exists(entity)) return; // already tracking
		listeners.set(entity, [
			entity.componentAdded.handle(function() addEntityIfMatch(entity)),
			entity.componentRemoved.handle(function() removeEntityIfNoLongerMatch(entity)),
		]);
	}
	
	function untrack(entity:ecs.entity.Entity) {
		if(!listeners.exists(entity)) return; // not tracking
		var l = listeners.get(entity);
		while(l.length > 0) l.pop().dissolve();
		listeners.remove(entity);
	}
}

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
	
	
	public function destroy() {
		
	}
	
	public inline function iterator() return nodes.iterator();
	inline function get_empty() return Lambda.empty(nodes);
	function get_head() {
		for(node in nodes) return node;
		return null;
	}
}
