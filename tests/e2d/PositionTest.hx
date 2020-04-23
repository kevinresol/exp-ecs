package e2d;

import exp.ecs.Engine;
import exp.ecs.entity.Entity;
import exp.ecs.component.e2d.Position;
import exp.ecs.system.e2d.PositionSystem;

@:asserts
class PositionTest extends Base {
	@:include
	public function test() {
		var engine = new Engine();
		engine.systems.add(new PositionSystem());
		
		function make(x, y) {
			var e = new Entity();
			var pos = new Position(x, y);
			e.add(pos);
			engine.entities.add(e);
			return pos;
		}
		
		var pos1 = make(1, 1);
		var pos2 = make(2, 2);
		var pos3 = make(3, 3);
		
		pos3.parent = pos2;
		pos2.parent = pos1;
		
		function check() {
			engine.update(0);
			asserts.assert(pos1.global.x == pos1.x);
			asserts.assert(pos1.global.y == pos1.y);
			asserts.assert(pos2.global.x == pos1.x + pos2.x);
			asserts.assert(pos2.global.y == pos1.y + pos2.y);
			asserts.assert(pos3.global.x == pos1.x + pos2.x + pos3.x);
			asserts.assert(pos3.global.y == pos1.y + pos2.y + pos3.y);
		}
		
		check();
		
		pos1.x = 4;
		check();
		
		pos2.x = 5;
		check();
		
		pos3.x = 6;
		check();
		
		return asserts.done();
	}
}