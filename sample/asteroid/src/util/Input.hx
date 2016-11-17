package util;

import openfl.display.*;
import openfl.events.*;

class Input {
	var display:DisplayObject;
	var keys:Array<Bool>; // TODO: what a naive but quick & dirty method
	
	public function new(display:DisplayObject) {
		display.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		display.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		keys = [];
	}
	
	public function isDown(key:Int) {
		return keys[key] == true;
	}
	function onKeyDown(e:KeyboardEvent) {
		keys[e.keyCode] = true;
	}
	function onKeyUp(e:KeyboardEvent) {
		keys[e.keyCode] = false;
	}
}