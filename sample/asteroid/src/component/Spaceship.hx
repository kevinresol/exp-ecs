package component;

import ecs.component.*;
import ecs.state.*;

class Spaceship extends Component {
	public var fsm:EntityStateMachine;
	public function new(fsm)
		this.fsm = fsm;
}
