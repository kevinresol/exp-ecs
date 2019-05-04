package component;

import exp.ecs.component.*;
import exp.ecs.entity.*;

class State extends Component {	
	public var fsm:EntityStateMachine;
	
	public function new(fsm) {
		this.fsm = fsm;
	}
}