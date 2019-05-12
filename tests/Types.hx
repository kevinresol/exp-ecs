package;

import exp.ecs.component.*;
import exp.ecs.system.*;
import exp.ecs.node.*;
import tink.state.State;

class Observable extends Component {	
	public var state:State<Int>;
	
	public function new(value) {
		this.state = new State(value);
	}
}
class Velocity extends Component {	
	public var x:Float;
	public var y:Float;
	
	public function new(x, y) {
		this.x = x;
		this.y = y;
	}
}

class Position extends Component {	
	public var x:Float;
	public var y:Float;
	
	public function new(x, y) {
		this.x = x;
		this.y = y;
	}
}

typedef MovementNode = Node<Position, Velocity>;
typedef OptionalNode = Node<{
	position:Position,
	?velocity:Velocity,
}>;

class MovementSystem<Event> extends System<Event> {
	@:nodes var nodes:MovementNode;
}
class RenderSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<Position>;
}

enum Events {
	
}