package util;

class Input {
	var keys:Array<Bool>; // TODO: what a naive but quick & dirty method
	
	public function new() {
		keys = [];
	}
	
	public function isDown(key:Int) {
		return keys[key] == true;
	}
	public function keyDown(code:Int) {
		keys[code] = true;
	}
	public function keyUp(code:Int) {
		keys[code] = false;
	}
}