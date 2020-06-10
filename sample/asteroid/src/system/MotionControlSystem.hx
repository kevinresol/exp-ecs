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
			
			var delta = 0.;
			if(input.isDown(control.left)) delta -= control.rotationRate * dt;
			if(input.isDown(control.right)) delta += control.rotationRate * dt;
			if(delta != 0) transform.rotation += delta;
			if(input.isDown(control.accelerate)) {
				motion.velocity.x += transform.a * control.accelerationRate * dt;
				motion.velocity.y += transform.b * control.accelerationRate * dt;
			}
		}
	}
}