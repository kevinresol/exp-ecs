package exp.ecs.entity;

import exp.ecs.component.*;
using tink.CoreApi;

class Entity {
	
	public var id(default, null):Int;
	public var componentAdded:Signal<Component>;
	public var componentRemoved:Signal<Component>;
	
	var components:Map<ComponentType, Component>;
	var componentAddedTrigger:SignalTrigger<Component>;
	var componentRemovedTrigger:SignalTrigger<Component>;
	var name:String;
	
	static var ids:Int = 0;
	
	public function new(?name) {
		this.id = ++ids;
		this.name = name;
		components = new Map();
		componentAdded = componentAddedTrigger = Signal.trigger();
		componentRemoved = componentRemovedTrigger = Signal.trigger();
	}
	
	public function add(component:Component, ?type:ComponentType) {
		if(type == null) type = component;
		if(components.exists(type)) remove(type);
		components.set(type, component);
		componentAddedTrigger.trigger(component);
	}
	
	public function remove(type:ComponentType) {
		var component = components.get(type);
		if(component != null) {
			components.remove(type);
			componentRemovedTrigger.trigger(component);
		}
		return component;
	}
	
	public inline function get<T:Component>(type:Class<T>):T {
		return cast components.get((cast type:Class<Component>));
	}
	
	public inline function has(type:ComponentType) {
		return components.exists(type);
	}
	
	public function hasAll(types:Array<ComponentType>) {
		for(type in types) if(!has(type)) return false;
		return true;
	}
	
	public function destroy() {
		components = null;
		componentAddedTrigger.clear();
		componentRemovedTrigger.clear();
		componentAddedTrigger = null;
		componentRemovedTrigger = null;
	}
	
	public function toString():String {
		return name == null ? 'Entity#$id' : name;
	}
}