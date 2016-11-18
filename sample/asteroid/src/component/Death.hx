package component;

import ecs.*;

class Death implements Component {
	public var countdown:Float;
	public function new(countdown)
		this.countdown = countdown;
		
}
