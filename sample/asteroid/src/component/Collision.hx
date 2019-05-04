package component;

import exp.ecs.component.*;

class Collision extends Component {
	public var group:Int;
	public var with:Array<Int>;
	public var radius:Int;
	public function new(group, with, radius) {
		this.group = group;
		this.with = with;
		this.radius = radius;
	}
		
}
