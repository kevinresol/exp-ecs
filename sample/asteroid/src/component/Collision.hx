package component;

import ecs.component.*;

class Collision extends Component {
	public var groups:Array<Int>;
	public var radius:Int;
	public function new(groups, radius) {
		this.groups = groups;
		this.radius = radius;
	}
		
}
