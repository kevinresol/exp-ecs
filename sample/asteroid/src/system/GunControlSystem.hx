package system;

import component.*;
import ecs.node.*;
import ecs.system.*;
import util.*;

using tink.CoreApi;

class GunControlSystem<Event:EnumValue> extends System<Event> {
	@:nodes var nodes:Node<GunControls, Position, Gun>;
	var input:Input;
	
	public function new(input) {
		super();
		this.input = input;
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var control = node.gunControls;
			var position = node.position;
			var gun = node.gun;
			
			var triggered = input.isDown(control.trigger);
			gun.elapsed += dt;
			if(triggered && gun.elapsed > gun.interval) {
				engine.entities.add(new entity.Bullet(gun, position));
				gun.elapsed = 0;
			}
		}
	}
}