package component;

import ecs.component.*;

class Position extends Component {	
	public var x:Float;
	public var y:Float;
	
	public function new(x, y) {
		this.x = x;
		this.y = y;
	}
}