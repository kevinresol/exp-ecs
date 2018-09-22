package ecs.entity;

import ecs.component.*;

class EntityStateMachine {
	var entity:Entity;
	var states:Map<String, EntityState>;
	var current:EntityState;
	
	public function new(entity) {
		this.entity = entity;
		states = new Map();
	}
	
	public function add(name:String, state:EntityState) {
		states.set(name, state);
	}
	
	public function change(name:String) {
		var toAdd = switch states.get(name) {
			case null: throw 'Entity state "$name" does not exist';
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
				current = next;
				toAdd;
			case next: 
				current = next;
				next.providers;
		}
		for(key in toAdd.keys())
			entity.add(toAdd[key].get(), key);
	}
}
