package component;

import exp.ecs.component.*;

class Display extends Component {
	public var object:#if openfl openfl.display.DisplayObject #elseif luxe luxe.Visual #end;
	public function new(object) {
		this.object = object;
		#if luxe object.visible = false; #end
	}
}
