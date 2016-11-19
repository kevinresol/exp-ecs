package component;

import ecs.component.*;
import util.*;

class Motion extends Component {
	public var velocity:Point;
	public var angularVelocity:Float;
	public var damping:Float;
	
	public function new(x, y, a, d) {
		velocity = new Point(x, y);
		angularVelocity = a;
		damping = d;
	}
}