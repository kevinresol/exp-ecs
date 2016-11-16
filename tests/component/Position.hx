package component;

class Position implements ecs.Component {	
	public var x:Float;
	public var y:Float;
	
	public function new(x, y) {
		this.x = x;
		this.y = y;
	}
}