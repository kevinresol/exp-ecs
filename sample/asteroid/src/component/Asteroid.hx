package component;

import ecs.component.*;

class Asteroid extends Component {
	public var radius:Int;
	public function new(radius) {
		this.radius = radius;
	}
}
