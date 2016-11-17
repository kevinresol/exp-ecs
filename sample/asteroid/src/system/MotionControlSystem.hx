package system;

import ecs.Engine;
import ecs.Node;
import ecs.System;
import node.Nodes;
import util.*;

using tink.CoreApi;

class MotionControlSystem extends NodeListSystem<MotionControlNode> {
	var input:Input;
	
	public function new(input) {
		super();
		this.input = input;
	}
	
	override function updateNode(node:MotionControlNode, dt:Float) {
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