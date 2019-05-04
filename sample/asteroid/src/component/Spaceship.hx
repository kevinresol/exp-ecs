package component;

import exp.ecs.component.*;
import exp.ecs.state.*;

class Spaceship extends Component {
	public var fsm:EntityStateMachine;
	public function new(fsm)
		this.fsm = fsm;
}
