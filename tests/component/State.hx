package component;

class State extends ecs.Component {	
	public var fsm:ecs.EntityStateMachine;
	
	public function new(fsm) {
		this.fsm = fsm;
	}
}