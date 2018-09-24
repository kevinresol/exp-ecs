package ecs;

import ecs.entity.*;
import ecs.node.*;
import ecs.node.NodeList;
import ecs.system.*;

using tink.CoreApi;

class Engine {
	
	public var entities(default, null):ReadOnlyArray<Entity>;
	public var entityAdded(default, null):Signal<Entity>;
	public var entityRemoved(default, null):Signal<Entity>;
	public var systems:ReadOnlyArray<SystemBase>;
	
	var _entities:Array<Entity>;
	var _systems:Array<SystemBase>;
	var nodeLists:Map<NodeType, NodeList<Dynamic>>;
	
	var entityAddedTrigger:SignalTrigger<Entity>;
	var entityRemovedTrigger:SignalTrigger<Entity>;
	
	public function new() {
		entities = _entities = [];
		systems = _systems = [];
		nodeLists = new Map();
		entityAdded = entityAddedTrigger = Signal.trigger();
		entityRemoved = entityRemovedTrigger = Signal.trigger();
	}
	
	public function update(dt:Float) {
		for(system in _systems)
			system.update(dt);
	}
	
	public function addEntity(entity:Entity) {
		removeEntity(entity); // re-add to the end of the list
		_entities.push(entity);
		entityAddedTrigger.trigger(entity);
	}
	
	public function removeEntity(entity:Entity) {
		if(_entities.remove(entity))
			entityRemovedTrigger.trigger(entity);
	}
	
	public function addSystem(system:System) {
		removeSystem(system); // re-add to the end of the list
		_systems.push(system);
		system.onAdded(this);
	}
	
	public function removeSystem(system:System) {
		if(_systems.remove(system))
			system.onRemoved(this);
	}
	
	public function getNodeList<T:NodeBase>(type:NodeType, factory:Engine->NodeList<T>):NodeList<T> {
		if(!nodeLists.exists(type)) nodeLists.set(type, factory(this));
		return cast nodeLists.get(type);
	}
	
	public function toString() {
		var buf = new StringBuf();
		// buf.add(entities);
		// buf.add([for(s in systems) s.toString()]);
		// buf.add(nodeLists);
		return buf.toString();
	}
}