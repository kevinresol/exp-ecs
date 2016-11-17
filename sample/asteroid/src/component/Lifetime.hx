package component;

import ecs.*;

class Lifetime implements Component {
	public var lifetime:Float;
	public function new(lifetime)
		this.lifetime = lifetime;
}
