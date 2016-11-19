package component;

import ecs.component.*;
import ecs.entity.*;

class State extends Component {	
	public var fsm:EntityStateMachine;
	
	public function new(fsm) {
		this.fsm = fsm;
	}
}