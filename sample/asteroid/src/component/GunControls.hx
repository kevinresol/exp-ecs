package component;

import exp.ecs.component.*;

class GunControls extends Component {
	public var trigger:Int;
	public function new(trigger:Int) {
		this.trigger = trigger;
	}
}
