package component;

import exp.ecs.component.*;
import util.*;

class Gun extends Component {
	public var offset:Point;
	public var elapsed:Float = 0;
	public var interval:Float;
	public var bulletLifeTime:Float;
	
	public function new(x, y, i, l) {
		offset = new Point(x, y);
		interval = i;
		bulletLifeTime = l;
	}
}