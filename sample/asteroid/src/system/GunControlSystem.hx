package system;

import component.*;
import exp.ecs.node.*;
import exp.ecs.system.*;
import exp.ecs.component.e2d.*;
import util.*;

using tink.CoreApi;

class GunControlSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<GunControls, Transform, Gun>;
	var input:Input;
	
	public function new(input) {
		super();
		this.input = input;
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var control = node.gunControls;
			var transform = node.transform;
			var gun = node.gun;
			
			var triggered = input.isDown(control.trigger);
			gun.elapsed += dt;
			if(triggered && gun.elapsed > gun.interval) {
				engine.entities.add(new entity.Bullet(gun, transform));
				gun.elapsed = 0;
			}
		}
	}
}