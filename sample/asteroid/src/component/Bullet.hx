package component;

import ecs.component.*;

class Bullet extends Component {
	public var lifetime:Float;
	public function new(lifetime)
		this.lifetime = lifetime;
}
