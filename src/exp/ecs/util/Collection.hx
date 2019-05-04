package exp.ecs.util;

import tink.state.*;

using tink.CoreApi;

class Collection<Item> {
	var pending:Array<Pair<Item, Operation>>;
	var locked:State<Bool>;
	
	public function new() {
		pending = [];
		locked = new State(false);
	}
	
	public inline function lock() {
		locked.set(true);
	}
	
	public inline function unlock() {
		locked.set(false);
	}
	
	public function destroy() {}
	
	function schedule(item:Item, operation:Operation) {
		if(locked.value) {
			if(pending.length == 0)
				locked.observe().nextTime(function(v) return !v).handle(update);
			pending.push(new Pair(item, operation));
		} else {
			operate(item, operation);
		}
	}
	
	function update(_) {
		for(v in pending) operate(v.a, v.b);
		pending = [];
	}
	
	function operate(item:Item, operation:Operation) {}
	
}

@:enum
abstract Operation(Bool) to Bool {
	var Add = true;
	var Remove = false;
	
	public inline function isAdd():Bool
		return this;
}