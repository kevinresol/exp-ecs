package exp.ecs;

@:allow(exp.ecs)
class Entity extends Object<Entity> {
	public var removed(default, null):Bool = false;

	function new(id) {
		super(id, 'Entity');
	}

	inline function setRemoved() {
		removed = true;
	}
}
