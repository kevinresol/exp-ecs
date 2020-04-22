package exp.ecs.entity;

import exp.ecs.util.Collection;

using tink.CoreApi;

class EntityCollection extends Collection<Entity> {
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
	
	public inline function remove(entity:Entity, destroy = false)
		schedule(entity, destroy ? RemoveAndDestroy : Remove);
	
	override function operate(entity:Entity, operation:Operation) {
		switch operation {
			case Add:
				remove(entity); // re-add to the end of the list
				array.push(entity);
				addedTrigger.trigger(entity);
			case Remove | RemoveAndDestroy:
				if(array.remove(entity))
					removedTrigger.trigger(entity);
				if(operation == RemoveAndDestroy)
					entity.destroy();
		}
	}
	
	override function destroy() {
		// for(entity in array) entity.destroy(); // rethink: should we do this?
		array = null;
		addedTrigger.clear();
		removedTrigger.clear();
		addedTrigger = null;
		removedTrigger = null;
	}
	
	public inline function iterator()
		return array.iterator();
}

