package ecs.node;

import ecs.*;
import ecs.entity.*;
import ecs.node.Node;
import ecs.component.*;

using tink.CoreApi;

class TrackingNodeList<T:NodeBase> extends NodeList<T> {
	var componentTypes:Array<ComponentType>;
	var engine:Engine;
	var listeners:Map<Entity, CallbackLink> = new Map();
	var binding:CallbackLink;
	
	public function new(engine, factory, componentTypes) {
		super(factory);
		
		this.engine = engine;
		this.componentTypes = componentTypes;
		
		for(entity in engine.entities) {
			track(entity);
			if(entity.hasAll(componentTypes)) add(entity);
		}
			
		binding = [
			engine.entityAdded.handle(function(entity) {
				track(entity);
				if(entity.hasAll(componentTypes)) add(entity);
			}),
			engine.entityRemoved.handle(function(entity) {
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
			entity.componentAdded.handle(function(c) {
				if(entity.hasAll(componentTypes)) add(entity);
			}),
			entity.componentRemoved.handle(function(c) {
				if(!entity.hasAll(componentTypes)) remove(entity);
			}),
		]);
	}
	
	function untrack(entity:Entity) {
		if(!listeners.exists(entity)) return; // not tracking
		listeners.get(entity).dissolve();
		listeners.remove(entity);
	}
	
	override function toString():String {
		return 'TrackingNodeList#' + componentTypes.map(function(type) return type.split('.').pop()).join(',');
	}
}