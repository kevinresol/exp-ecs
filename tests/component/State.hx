package component;

import ecs.*;

class State implements ecs.Component {	
	public var fsm:EntityStateMachine;
	
	public function new(fsm) {
		this.fsm = fsm;
	}
}