package component;

import ecs.*;

class Bullet implements Component {
	public var lifetime:Float;
	public function new(lifetime)
		this.lifetime = lifetime;
}
