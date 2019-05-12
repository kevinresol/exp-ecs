package;

import Types;
import exp.ecs.node.*;
import exp.ecs.entity.*;

@:asserts
class NodeTest {
	public function new() {}
	
	public function typeEquality() {
		var entity = new Entity();
		
		var node1 = new Node<Velocity>(entity);
		var node2 = new Node<Velocity>(entity);
		asserts.assert(Type.getClass(node1) == Type.getClass(node2));
		
		var node1 = new Node<Velocity, Position>(entity);
		var node2 = new Node<Velocity, Position>(entity);
		asserts.assert(Type.getClass(node1) == Type.getClass(node2));
		
		var node1 = new Node<Position, Velocity>(entity);
		var node2 = new Node<Velocity, Position>(entity);
		asserts.assert(Type.getClass(node1) == Type.getClass(node2));
		
		return asserts.done();
	}
}