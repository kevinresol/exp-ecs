package component;

import ecs.*;

class GunControls implements Component {
	public var trigger:Int;
	public function new(trigger:Int) {
		this.trigger = trigger;
	}
}
