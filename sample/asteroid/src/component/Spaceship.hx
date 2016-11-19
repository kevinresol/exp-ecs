package component;

import ecs.*;

class Spaceship extends Component {
	public var fsm:EntityStateMachine;
	public function new(fsm)
		this.fsm = fsm;
}
