package component;

import ecs.*;

typedef Object = #if openfl openfl.display.DisplayObject #elseif luxe luxe.Visual #end;
class Display extends Component {
	public var object:Object;
	public function new(object) {
		this.object = object;
		#if luxe object.visible = false; #end
	}
}
