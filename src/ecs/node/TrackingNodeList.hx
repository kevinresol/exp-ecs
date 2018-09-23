package ecs.node;

import ecs.*;
import ecs.entity.*;
import ecs.node.Node;
import ecs.component.*;

using tink.CoreApi;

class TrackingNodeList<T:NodeBase> extends NodeList<T> {
	
	public var id(default, null):Int;
	
	var condition:Entity->Bool;
	var engine:Engine;
	var listeners:Map<Entity, CallbackLink> = new Map();
	var binding:CallbackLink;
	var name:String;
	
	static var ids:Int = 0;
	
	public function new(engine, factory, condition, ?name) {
		super(factory);
		
		this.engine = engine;
		this.condition = condition;
		this.name = name;
		this.id == ++ids;
		
		for(entity in engine.entities) {
			track(entity);
			if(condition(entity)) add(entity);
		}
			
		binding = [
			engine.entityAdded.handle(function(entity) {
				track(entity);
				if(condition(entity)) add(entity);
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