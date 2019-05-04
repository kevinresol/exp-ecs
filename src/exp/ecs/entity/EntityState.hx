package exp.ecs.entity;

import exp.ecs.component.*;

class EntityState {
	
	public var providers:Map<ComponentType, ComponentProvider>;
	
	public function new() {
		providers = new Map();
	}
	
	public function add(type:ComponentType, provider:ComponentProvider) {
		providers.set(type, provider);
	}
}