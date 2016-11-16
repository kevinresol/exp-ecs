package ecs;

import ecs.Component;

class Entity {
	
	var components:Map<ComponentType, Component>;
	
	public function new() {
		components = new Map();
	}
	
	public function add(component:Component, ?type:ComponentType) {
		if(type == null) type = component;
		if(components.exists(type)) remove(type);
		components.set(type, component);
		// TODO: dispatch signal
	}
	
	public function remove(type:ComponentType) {
		var component = components.get(type);
		if(component != null) {
			components.remove(type);
			// TODO: dispatch signal
		}
		return component;
	}
	
	public function get<T:Component>(type:ComponentType):T {
		return cast components.get(type);
	}
	
	public function hasAll(types:Array<ComponentType>) {
		for(type in types) if(!components.exists(type)) return false;
		return true;
	}
}