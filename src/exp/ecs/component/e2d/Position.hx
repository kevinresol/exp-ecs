package exp.ecs.component.e2d;

import exp.ecs.entity.Entity;

class Position extends Component {
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var parent(default, set):Null<Position>;
	public var global(default, null):Global = new Global(0, 0);

	@:noCompletion var dirty:Bool = true;

	public function new(x, y, ?parent) {
		this.x = x;
		this.y = y;
		this.parent = parent;
	}

	function set_x(v:Float):Float {
		if (x != v)
			dirty = true;
		return x = v;
	}

	function set_y(v:Float):Float {
		if (y != v)
			dirty = true;
		return y = v;
	}

	function set_parent(v:Position):Position {
		if (parent != v)
			dirty = true;
		return parent = v;
	}
}

private class Global {
	public var x(default, null):Float;
	public var y(default, null):Float;

	public function new(x, y) {
		this.x = x;
		this.y = y;
	}

	inline function set(x, y) {
		this.x = x;
		this.y = y;
	}
}
