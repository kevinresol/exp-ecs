package system;

import component.*;
import ecs.Node;
import ecs.System;
import util.*;

using tink.CoreApi;

class MotionControlSystem extends NodeListSystem<{nodes:Node<MotionControls, Position, Motion>}> {
	var input:Input;
	
	public function new(input) {
		super();
		this.input = input;
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var control = node.motionControls;
			var position = node.position;
			var motion = node.motion;
			
			if(input.isDown(control.left)) position.rotation -= control.rotationRate * dt;
			if(input.isDown(control.right)) position.rotation += control.rotationRate * dt;
			if(input.isDown(control.accelerate)) {
				motion.velocity.x += Math.cos(position.rotation) * control.accelerationRate * dt;
				motion.velocity.y += Math.sin(position.rotation) * control.accelerationRate * dt;
			}
		}
	}
}