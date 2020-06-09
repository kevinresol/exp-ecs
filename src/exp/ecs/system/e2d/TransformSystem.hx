package exp.ecs.system.e2d;

import exp.ecs.node.Node;
import exp.ecs.component.e2d.*;

@:access(exp.ecs)
class TransformSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<Transform>;

	override function update(dt:Float) {
		// mark self as dirty if any ancestors is dirty
		for (node in nodes) {
			var transform = node.transform;
			if (!transform.dirty) {
				var parent = transform.parent;
				while (parent != null) {
					if (parent.dirty) {
						markDirty(transform, parent);
						break;
					}
					parent = parent.parent;
				}
			}
		}

		// clean all
		for (node in nodes)
			clean(node.transform);
	}
	
	inline function markDirty(current:Transform, upto:Transform) {
		while(current != upto) {
			current.dirty = true;
			current = current.parent;
		}
	}
	
	inline function clean(transform:Transform) {
		if(transform.dirty) {
			var parent = transform.parent;
			if(parent != null) {
				clean(parent);
				(parent.global.toMatrix() * transform.local).copyTo(transform.global.toMatrix());
			} else {
				transform.local.copyTo(transform.global.toMatrix());
			}
			transform.dirty = false;
		}
		
	}
}
