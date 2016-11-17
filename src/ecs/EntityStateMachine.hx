package ecs;

import ecs.Component;

class EntityStateMachine<T:EnumValue> {
	var entity:Entity;
	var states:Map<T, EntityState>;
	var current:EntityState;
	
	public function new(entity) {
		this.entity = entity;
		states = new Map();
	}
	
	public function add(name:T, state:EntityState) {
		states.set(name, state);
	}
	
	public function change(name:T) {
		var toAdd = switch states.get(name) {
			case null: throw 'Entity state $name does not exist';
			case next if(next == current): return;
			case next if(current != null):
				var toAdd = new Map();
				for(key in next.providers.keys()) toAdd.set(key, next.providers[key]);
				for(key in current.providers.keys()) {
					if(toAdd.exists(key) && toAdd[key].identifier() == current.providers[key].identifier())
						toAdd.remove(key);
					else
						entity.remove(key);
				}
				toAdd;
			case next: next.providers;
		}
		for(key in toAdd.keys())
			entity.add(toAdd[key].get(), key);
	}
}

class EntityState {
	
	public var providers:Map<ComponentType, ComponentProvider>;
	
	public function new() {
		providers = new Map();
	}
	
	public function add(type:ComponentType, provider:ComponentProvider) {
		providers.set(type, provider);
	}
}