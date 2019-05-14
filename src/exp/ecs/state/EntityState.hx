package exp.ecs.state;

import exp.fsm.State;
import exp.ecs.component.*;
import exp.ecs.entity.*;

class EntityState<T> extends State<T> {
	var entity:Entity;
	var components:Array<Component>;
	public function new(key, next, entity, components) {
		super(key, next);
		this.entity = entity;
		this.components = components;
	}
	
	override function onActivate() {
		for(component in components) entity.add(component);
	}
	
	override function onDeactivate() {
		for(component in components) entity.remove(component);
	}
}