package;

class GameState {
	public var lives:Int;
	public var level:Int;
	public var points:Int;
	public var over:Bool;
	
	public function new()
		reset();
		
	public function reset() {
		lives = 1;
		level = 0;
		points = 0;
		over = false;
	}
}