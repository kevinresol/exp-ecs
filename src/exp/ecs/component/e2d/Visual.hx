package exp.ecs.component.e2d;

class Visual extends Component {
	public var object:openfl.display.DisplayObject;
	
	public function new(object) {
		this.object = object;
	}
	
	public inline function setTransform(transform:Transform) {
		@:privateAccess object.transform.__setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
	}
}