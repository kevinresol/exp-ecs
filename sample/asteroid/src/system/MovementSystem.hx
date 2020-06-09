package system;

import component.*;
import exp.ecs.node.*;
import exp.ecs.system.*;
import exp.ecs.component.e2d.*;
import util.*;

using tink.CoreApi;

class MovementSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<Transform, Motion>;
	
	var config:Config;
	
	public function new(config) {
		super();
		this.config = config;
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var transform = node.transform;
			var motion = node.motion;
			
			transform.tx += motion.velocity.x * dt;
			transform.ty += motion.velocity.y * dt;
			if(transform.tx < 0) transform.tx += config.width;
			if(transform.tx > config.width) transform.tx -= config.width;
			if(transform.ty < 0) transform.ty += config.height;
			if(transform.ty > config.height) transform.ty -= config.height;
			transform.rotation += motion.angularVelocity * dt;
			
			if(motion.damping > 0) {
				var x = Math.abs(Math.cos(transform.rotation)) * motion.damping * dt;
				var y = Math.abs(Math.sin(transform.rotation)) * motion.damping * dt;
				if(motion.velocity.x > x) motion.velocity.x -= x;
				else if(motion.velocity.x < -x) motion.velocity.x += x;
				else motion.velocity.x = 0;
				if(motion.velocity.y > y) motion.velocity.y -= y;
				else if(motion.velocity.y < -y) motion.velocity.y += y;
				else motion.velocity.y = 0;
			}
		}
	}
}