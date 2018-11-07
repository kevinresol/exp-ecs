package ecs.system;

import ecs.*;
import haxe.PosInfos;
import tink.priority.*;

class SystemCollection<Event> {
	var queue:Queue<System<Event>>;
	var engine:Engine<Event>;
	
	public function new(engine) {
		this.engine = engine;
		queue = new Queue();
	}
	
	public inline function add(system:System<Event>, ?id:SystemId, ?pos:PosInfos) {
		addBetween(null, null, system, id, pos);
	}
	
	public inline function addBefore(before:SystemId, system:System<Event>, ?id:SystemId, ?pos:PosInfos) {
		addBetween(before, null, system, id, pos);
	}
	
	public inline function addAfter(after:SystemId, system:System<Event>, ?id:SystemId, ?pos:PosInfos) {
		addBetween(null, after, system, id, pos);
	}
	
	public function addBetween(before:SystemId, after:SystemId, system:System<Event>, ?id:SystemId, ?pos:PosInfos) {
		if(id == null) id = system;
		if(before == null && after == null) {
			var all = @:privateAccess queue.toArray();
			after = all[all.length - 1];
		}
		queue.between(selector(after), selector(before), system, id, pos);
		system.onAdded(engine);
	}
	
	public function remove(system:System<Event>) {
		if(queue.remove(system))
			system.onRemoved(engine);
	}
	
	function selector(id:SystemId):Selector<System<Event>>
		return id == null ? null : function(i:Item<System<Event>>) return i.id == new ID(id);
	
	public inline function iterator()
		return queue.iterator();
}
