package component;

import ecs.*;

class Spaceship implements Component {
	public var fsm:EntityStateMachine;
	public function new(fsm)
		this.fsm = fsm;
}
