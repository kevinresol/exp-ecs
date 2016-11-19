package component;

import ecs.*;

class Display extends Component {
	public var object:openfl.display.DisplayObject;
	public function new(object)
		this.object = object;
}
