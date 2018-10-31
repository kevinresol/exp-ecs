package ecs.util;

class ConstArrayIterator<T> {

	var cur:Int;
	var max:Int;
	var array:Array<T>;

	public inline function new(arr:Array<T>) {
		cur = 0;
		max = arr.length;
		array = arr;
	}

	public inline function hasNext():Bool {
		return cur != max;
	}

	public inline function next():T {
		return array[cur++];
	}
}