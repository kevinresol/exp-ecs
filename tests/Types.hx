package;

import exp.ecs.component.*;
import exp.ecs.system.*;
import exp.ecs.node.*;

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

class MovementSystem<Event> extends System<Event> {}

enum Events {
	
}