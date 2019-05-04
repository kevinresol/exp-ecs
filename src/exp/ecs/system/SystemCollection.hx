package exp.ecs.system;

import exp.ecs.*;
import exp.ecs.util.Collection;
import haxe.PosInfos;
import tink.priority.*;

class SystemCollection<Event> extends Collection<Item<System<Event>>> {
	var queue:Queue<System<Event>>;
	var engine:Engine<Event>;
	
	public function new(engine) {
		super();
		this.engine = engine;
		queue = new Queue();
	}
	
	public function add(system:System<Event>, ?id:SystemId, ?pos:PosInfos) {
		if(id == null) id = system;
		var all = @:privateAccess queue.toArray();
		var after = all[all.length - 1];
		schedule({data: system, id: new ID(id), after: selector(after)}, Add);
	}
	
	public function addBefore(before:SystemId, system:System<Event>, ?id:SystemId, ?pos:PosInfos) {
		if(id == null) id = system;
		schedule({data: system, id: new ID(id), before: selector(before)}, Add);
	}
	
	public function addAfter(after:SystemId, system:System<Event>, ?id:SystemId, ?pos:PosInfos) {
		if(id == null) id = system;
		schedule({data: system, id: new ID(id), after: selector(after)}, Add);
	}
	
	public function addBetween(before:SystemId, after:SystemId, system:System<Event>, ?id:SystemId, ?pos:PosInfos) {
		if(id == null) id = system;
		schedule({data: system, id: new ID(id), before: selector(before), after: selector(after)}, Add);
	}
	
	public inline function remove(system:System<Event>) {
		schedule({data: system}, Remove);
	}
		
	override function operate(item:Item<System<Event>>, operation:Operation) {
		var system = item.data;
		if(operation.isAdd()) {
			queue.add(item);
			system.onAdded(engine);
		} else {
			if(queue.remove(system))
				system.onRemoved(engine);
		}
	}
	
	
	override function destroy() {
		queue = null;
		engine = null;
	}
	
	public inline function iterator()
		return queue.iterator();
	
	function selector(id:SystemId):Selector<System<Event>>
		return id == null ? null : function(i:Item<System<Event>>) return i.id == new ID(id);
}
