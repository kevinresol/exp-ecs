package ecs.node;

import ecs.*;
import ecs.entity.*;
import ecs.node.Node;
import ecs.component.*;

using tink.CoreApi;

/**
 * This is a specialized NodeList implementation that will watch the engine's entity list and their component list and:
 * 1. add to the list those entities fulfilling the condition
 * 2. remove from the list those entities not fulfilling the condition
 */
class TrackingNodeList<T:NodeBase, Event> extends NodeList<T> {
	
	var condition:Entity->Bool;
	var engine:Engine<Event>;
	var listeners:Map<Entity, CallbackLink> = new Map();
	var binding:CallbackLink;
	
	public function new(engine, factory, condition, ?name) {
		super(factory, name);
		
		this.engine = engine;
		this.condition = condition;
		
		for(entity in engine.entities) {
			track(entity);
			if(condition(entity)) add(entity);
		}
			
		binding = [
			engine.entities.added.handle(function(entity) {
				track(entity);
				if(condition(entity)) add(entity);
			}),
			engine.entities.removed.handle(function(entity) {
				untrack(entity);
				remove(entity);
			}),
		];
	}
	
	override function destroy() {
		super.destroy();
		for(l in listeners) l.dissolve();
		listeners = null;
		binding.dissolve();
		binding = null;
	}
			
	function track(entity:Entity) {
		if(listeners.exists(entity)) return; // already tracking
		listeners.set(entity, [
			entity.componentAdded.handle(function(_) if(condition(entity)) add(entity)),
			entity.componentRemoved.handle(function(_) if(!condition(entity)) remove(entity)),
		]);
	}
	
	function untrack(entity:Entity) {
		if(!listeners.exists(entity)) return; // not tracking
		listeners.get(entity).dissolve();
		listeners.remove(entity);
	}
	
	override function toString():String {
		return name == null ? 'TrackingNodeList#$id' : name;
	}
}