package;

import exp.ecs.Engine;
import Types;
import exp.ecs.node.*;
import exp.ecs.entity.*;
import exp.ecs.system.*;

@:asserts
class SystemTest {
	public function new() {}
	
	public function typeEquality() {
		var engine = new Engine<MyEvents>();
		
		var entity = new Entity();
		entity.add(new Velocity(0, 0));
		entity.add(new Position(0, 0));
		engine.entities.add(entity);
		
		var system = new MySystem();
		engine.systems.add(system);
		
		asserts.assert(Type.getClass(system.nodes1.nodes[0]) == Type.getClass(system.nodes2.nodes[0]));
		asserts.assert(Type.getClass(system.nodes3.nodes[0]) == Type.getClass(system.nodes4.nodes[0]));
		asserts.assert(Type.getClass(system.nodes3.nodes[0]) == Type.getClass(system.nodes5.nodes[0]));
		asserts.assert(Type.getClass(system.nodes5.nodes[0]) == Type.getClass(system.nodes6.nodes[0]));
		
		return asserts.done();
	}
}

enum MyEvents {}

class MySystem extends System<MyEvents>{
	@:nodes public var nodes1:Node<Velocity>;
	@:nodes public var nodes2:Node<Velocity>;
	@:nodes public var nodes3:Node<Position, Velocity>;
	@:nodes public var nodes4:Node<Position, Velocity>;
	@:nodes public var nodes5:Node<Velocity, Position>;
	@:nodes public var nodes6:Node<Velocity, Position>;
}