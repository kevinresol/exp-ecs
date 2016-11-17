package component;

import ecs.*;
import util.*;

class Motion implements Component {
	public var velocity:Point;
	public var angularVelocity:Float;
	public var damping:Float;
	
	public function new(x, y, a, d) {
		velocity = new Point(x, y);
		angularVelocity = a;
		damping = d;
	}
}