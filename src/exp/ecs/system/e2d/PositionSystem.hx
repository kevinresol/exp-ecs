package exp.ecs.system.e2d;

import exp.ecs.node.Node;
import exp.ecs.component.e2d.*;

@:access(exp.ecs)
class PositionSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<Position>;

	override function update(dt:Float) {
		// mark self as dirty if any ancestors is dirty
		for (node in nodes) {
			var pos = node.position;
			if (!pos.dirty) {
				var parent = pos.parent;
				while (parent != null) {
					if (parent.dirty) {
						pos.dirty = true;
						break;
					}
					parent = parent.parent;
				}
			}
		}

		// clean all
		for (node in nodes)
			clean(node.position);
	}
	
	function clean(pos:Position) {
		if(pos.dirty) {
			var parent = pos.parent;
			if(parent != null) {
				clean(parent);
				pos.global.set(parent.global.x + pos.x, parent.global.y + pos.y);
			} else {
				pos.global.set(pos.x, pos.y);
			}
			pos.dirty = false;
		}
		
	}
}
