package component;

import ecs.*;

class Death extends Component {
	public var countdown:Float;
	public function new(countdown)
		this.countdown = countdown;
		
}
