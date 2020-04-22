package;

import Types;
import exp.ecs.node.*;
import exp.ecs.entity.*;

@:asserts
class NodeTest extends Base {
	public function typeEquality() {
		var entity = new Entity();
		
		var node1 = new Node<Velocity>(entity);
		var node2 = new Node<Velocity>(entity); // duplicated just to make sure they generate the same type
		asserts.assert(getClassName(node1) == getClassName(node2));
		
		var node1 = new Node<Velocity, Position>(entity);
		var node2 = new Node<Velocity, Position>(entity); // duplicated just to make sure they generate the same type
		var node3 = new Node<Position, Velocity>(entity);
		asserts.assert(getClassName(node1) == getClassName(node2));
		asserts.assert(getClassName(node2) == getClassName(node3));
		
		return asserts.done();
	}
	
	public function componentChange() {
		var entity = new Entity();
		var vel1 = new Velocity(1, 1);
		var vel2 = new Velocity(2, 2);
		var node = new Node<Velocity>(entity);
		
		asserts.assert(node.velocity == null, 'Initial reference');
		
		// new component
		entity.add(vel1);
		asserts.assert(node.velocity == vel1, 'Add reference to component');
		
		// change component
		entity.add(vel2);
		asserts.assert(node.velocity == vel2, 'Change reference to component');
		
		// remove component
		entity.remove(Velocity);
		asserts.assert(node.velocity == null, 'Remove reference to component');
		
		
		return asserts.done();
	}
}