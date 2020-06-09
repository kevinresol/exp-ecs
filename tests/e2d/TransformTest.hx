package e2d;

import exp.ecs.Engine;
import exp.ecs.entity.Entity;
import exp.ecs.component.e2d.Transform;
import exp.ecs.system.e2d.TransformSystem;

@:asserts
class TransformTest extends Base {
	@:include
	public function test() {
		var engine = new Engine();
		engine.systems.add(new TransformSystem());
		
		function make(x, y) {
			var e = new Entity();
			var transform = new Transform(1, 0, 0, 1, x, y);
			e.add(transform);
			engine.entities.add(e);
			return transform;
		}
		
		var transform1 = make(1, 1);
		var transform2 = make(2, 2);
		var transform3 = make(3, 3);
		
		transform3.parent = transform2;
		transform2.parent = transform1;
		
		function check() {
			engine.update(0);
			asserts.assert(transform1.global.tx == transform1.tx);
			asserts.assert(transform1.global.ty == transform1.ty);
			asserts.assert(transform2.global.tx == transform1.tx + transform2.tx);
			asserts.assert(transform2.global.ty == transform1.ty + transform2.ty);
			asserts.assert(transform3.global.tx == transform1.tx + transform2.tx + transform3.tx);
			asserts.assert(transform3.global.ty == transform1.ty + transform2.ty + transform3.ty);
		}
		
		check();
		
		transform1.tx = 4;
		check();
		
		transform2.tx = 5;
		check();
		
		transform3.tx = 6;
		check();
		
		return asserts.done();
	}
}