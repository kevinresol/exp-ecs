package util;

class Point {
	public var x:Float;
	public var y:Float;
	
	public function new(x, y) {
		this.x = x;
		this.y = y;
	}
	
	public static function distance(p1:Point, p2:Point) {
		var dx = p1.x - p2.x;
		var dy = p1.y - p2.y;
		return Math.sqrt(dx * dx + dy * dy);
	}
}
