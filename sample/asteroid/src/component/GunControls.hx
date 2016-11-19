package component;

import ecs.*;

class GunControls extends Component {
	public var trigger:Int;
	public function new(trigger:Int) {
		this.trigger = trigger;
	}
}
