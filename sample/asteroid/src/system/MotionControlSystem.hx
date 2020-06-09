package system;

import component.*;
import exp.ecs.node.*;
import exp.ecs.system.*;
import exp.ecs.component.e2d.*;
import util.*;

using tink.CoreApi;

class MotionControlSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<MotionControls, Transform, Motion>;
	var input:Input;
	
	public function new(input) {
		super();
		this.input = input;
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var control = node.motionControls;
			var transform = node.transform;
			var motion = node.motion;
			
			if(input.isDown(control.left)) transform.rotation -= control.rotationRate * dt;
			if(input.isDown(control.right)) transform.rotation += control.rotationRate * dt;
			if(input.isDown(control.accelerate)) {
				motion.velocity.x += Math.cos(transform.rotation) * control.accelerationRate * dt;
				motion.velocity.y += Math.sin(transform.rotation) * control.accelerationRate * dt;
			}
		}
	}
}