package component;

import ecs.component.*;

class Lifespan extends Component {
	public var lifespan:Float;
	public function new(lifespan)
		this.lifespan = lifespan;
}
