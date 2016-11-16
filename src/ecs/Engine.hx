package ecs;

import ecs.Node;
import tink.priority.Queue;

using tink.CoreApi;

class Engine {
	
	public var entities(default, null):Array<Entity>;
	public var entityAdded(default, null):Signal<Entity>;
	public var entityRemoved(default, null):Signal<Entity>;
	
	var systems:Queue<System>;
	var nodeLists:Map<NodeType, NodeList<Dynamic>>;
	
	var entityAddedTrigger:SignalTrigger<Entity>;
	var entityRemovedTrigger:SignalTrigger<Entity>;
	
	public function new() {
		entities = [];
		systems = new Queue();
		nodeLists = new Map();
		entityAdded = entityAddedTrigger = Signal.trigger();
		entityRemoved = entityRemovedTrigger = Signal.trigger();
	}
	
	public function update(dt:Float) {
		for(system in systems)
			system.update(dt);
	}
	
	public function addEntity(entity:Entity) {
		entities.remove(entity);
		entities.push(entity);
		entityAddedTrigger.trigger(entity);
	}
	
	public function removeEntity(entity:Entity) {
		if(entities.remove(entity))
			entityRemovedTrigger.trigger(entity);
	}
	
	public function addSystem(system:System) {
		systems.whenever(system);
		system.onAdded(this);
	}
	
	public function removeSystem(system:System) {
		if(systems.remove(system))
			system.onRemoved(this);
	}
	
	public macro function getNodeList(ethis, e) {
		return Macro.getNodeList(ethis, e);
	}
	
	function _getNodeList<T:NodeBase>(type:NodeType, factory:Engine->NodeList<T>):NodeList<T> {
		if(!nodeLists.exists(type)) nodeLists.set(type, factory(this));
		return cast nodeLists.get(type);
	}
}