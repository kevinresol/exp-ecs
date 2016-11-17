package component;

import ecs.*;

class Display implements Component {
	public var object:openfl.display.DisplayObject;
	public function new(object)
		this.object = object;
}
