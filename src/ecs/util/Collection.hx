package ecs.util;

import tink.state.*;

using tink.CoreApi;

class Collection<Item, Instruction> {
	var pending:Array<Pair<Instruction, Operation>>;
	var locked:State<Bool>;
	
	public function new() {
		pending = [];
		locked = new State(false);
	}
	
	public function lock() {
		locked.set(true);
	}
	
	public function unlock() {
		locked.set(false);
	}
	
	public function destroy() {}
	
	function schedule(instruction:Instruction, operation:Operation) {
		if(locked.value) {
			if(pending.length == 0)
				locked.observe().nextTime(function(v) return !v).handle(update);
			pending.push(new Pair(instruction, operation));
		} else {
			operate(instruction, operation);
		}
	}
	
	function update() {
		for(v in pending) operate(v.a, v.b);
		pending = [];
	}
	
	function operate(instruction:Instruction, operation:Operation) {}
	
}

@:enum
abstract Operation(Bool) to Bool {
	var Add = true;
	var Remove = false;
	
	public inline function isAdd():Bool
		return this;
}