package component;

import ecs.component.*;

class Death extends Component {
	public var countdown:Float;
	public function new(countdown)
		this.countdown = countdown;
		
}
