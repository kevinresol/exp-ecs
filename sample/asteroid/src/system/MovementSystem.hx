package system;

import component.*;
import ecs.Node;
import ecs.System;
import util.*;

using tink.CoreApi;

class MovementSystem extends NodeListSystem<{nodes:Node<Position, Motion>}> {
	var config:Config;
	
	public function new(config) {
		super();
		this.config = config;
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var position = node.position;
			var motion = node.motion;
			
			position.position.x += motion.velocity.x * dt;
			position.position.y += motion.velocity.y * dt;
			if(position.position.x < 0) position.position.x += config.width;
			if(position.position.x > config.width) position.position.x -= config.width;
			if(position.position.y < 0) position.position.y += config.height;
			if(position.position.y > config.height) position.position.y -= config.height;
			position.rotation += motion.angularVelocity * dt;
			
			if(motion.damping > 0) {
				var x = Math.abs(Math.cos(position.rotation)) * motion.damping * dt;
				var y = Math.abs(Math.sin(position.rotation)) * motion.damping * dt;
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