package ecs.entity;

import ecs.util.Collection;

using tink.CoreApi;

class EntityCollection extends Collection<Entity, Entity> {
	public var added(default, null):Signal<Entity>;
	public var removed(default, null):Signal<Entity>;
	
	var array:Array<Entity>;
	var addedTrigger:SignalTrigger<Entity>;
	var removedTrigger:SignalTrigger<Entity>;
	
	public function new() {
		super();
		array = [];
		added = addedTrigger = Signal.trigger();
		removed = removedTrigger = Signal.trigger();
	}
		
	public inline function add(entity:Entity)
		schedule(entity, Add);
	
	public inline function remove(entity:Entity)
		schedule(entity, Remove);
	
	override function operate(entity:Entity, operation:Operation) {
		if(operation.isAdd()) {
			remove(entity); // re-add to the end of the list
			array.push(entity);
			addedTrigger.trigger(entity);
		} else {
			if(array.remove(entity))
				removedTrigger.trigger(entity);
		}
	}
	
	override function destroy() {
		for(entity in array) entity.destroy();
		array = null;
		// TODO: destroy signals
	}
	
	public inline function iterator()
		return array.iterator();
}

