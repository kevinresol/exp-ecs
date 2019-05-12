package;

import exp.ecs.Engine;
import Types;
import exp.ecs.node.*;
import exp.ecs.entity.*;
import exp.ecs.system.*;

@:asserts
class SystemTest extends Base {
	public function typeEquality() {
		var engine = new Engine<MyEvents>();
		
		var entity = new Entity();
		entity.add(new Velocity(0, 0));
		entity.add(new Position(0, 0));
		engine.entities.add(entity);
		
		var system = new MySystem();
		engine.systems.add(system);
		
		asserts.assert(getClassName(system.single1.nodes[0]) == getClassName(system.single2.nodes[0]));
		asserts.assert(getClassName(system.single2.nodes[0]) == getClassName(system.single3.nodes[0]));
		
		asserts.assert(getClassName(system.double1.nodes[0]) == getClassName(system.double2.nodes[0]));
		asserts.assert(getClassName(system.double2.nodes[0]) == getClassName(system.double3.nodes[0]));
		asserts.assert(getClassName(system.double3.nodes[0]) == getClassName(system.double4.nodes[0]));
		asserts.assert(getClassName(system.double4.nodes[0]) == getClassName(system.double5.nodes[0]));
		asserts.assert(getClassName(system.double5.nodes[0]) == getClassName(system.double6.nodes[0]));
		
		// asserts.assert(Type.getClass(system.single1.nodes[0]) == Type.getClass(system.filtered1.nodes[0]));
		
		return asserts.done();
	}
}

enum MyEvents {}

class MySystem extends System<MyEvents>{
	@:nodes public var single1:Node<Velocity>;
	@:nodes public var single2:Node<Velocity>;
	@:nodes public var single3:Node<{var velocity:Velocity;}>;
	
	@:nodes public var double1:Node<Position, Velocity>;
	@:nodes public var double2:Node<Position, Velocity>;
	@:nodes public var double3:Node<Velocity, Position>;
	@:nodes public var double4:Node<Velocity, Position>;
	@:nodes public var double5:Node<{var position:Position; var velocity:Velocity;}>;
	@:nodes public var double6:Node<{var velocity:Velocity; var position:Position;}>;
	
	@:nodes public var filtered1:Node<{@:filter(_.x == 0) var velocity:Velocity;}>;
}