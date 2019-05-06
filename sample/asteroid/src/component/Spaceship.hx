package component;

import exp.ecs.component.*;
import exp.ecs.state.*;
import exp.fsm.*;

class Spaceship extends Component {
	public var fsm:StateMachine<String, EntityState<String>>;
	public function new(fsm)
		this.fsm = fsm;
}
