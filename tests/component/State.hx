package component;

import ecs.*;

class State<T:EnumValue> implements ecs.Component {	
	public var fsm:EntityStateMachine<T>;
	
	public function new(fsm) {
		this.fsm = fsm;
	}
}