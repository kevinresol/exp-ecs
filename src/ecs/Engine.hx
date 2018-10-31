package ecs;

import ecs.entity.*;
import ecs.node.*;
import ecs.node.NodeList;
import ecs.system.*;
import ecs.util.*;
import tink.state.State;

using tink.CoreApi;

class Engine<Event:EnumValue> {
	
	public var entities(default, null):EntityCollection;
	public var systems(default, null):SystemCollection<Event>;
	public var events(default, null):EventEmitter<Event>;
	
	var nodeLists:Map<NodeType, NodeList<Dynamic>>;
	var allowModifyEntities:State<Bool>;
	
	public function new() {
		allowModifyEntities = new State(true);
		entities = new EntityCollection(allowModifyEntities);
		systems = new SystemCollection(this);
		events = new EventEmitter();
		nodeLists = new Map();
	}
	
	public function update(dt:Float) {
		for(system in systems) {
			allowModifyEntities.set(false);
			system.update(dt);
			events.flushSystem();
			allowModifyEntities.set(true);
		}
		events.flushUpdate();
	}
	
	public function getNodeList<T:NodeBase>(type:NodeType, factory:Engine<Event>->NodeList<T>):NodeList<T> {
		if(!nodeLists.exists(type)) nodeLists.set(type, factory(this));
		return cast nodeLists.get(type);
	}
	
	public function destroy() {
		for(list in nodeLists) list.destroy();
		nodeLists = null;
		
		entities.destroy();
		entities = null;
		
		systems = null;
	}
	
	public function toString() {
		var buf = new StringBuf();
		// buf.add(entities);
		// buf.add([for(s in systems) s.toString()]);
		// buf.add(nodeLists);
		return buf.toString();
	}
}

class SystemCollection<Event:EnumValue> {
	var array:Array<System<Event>>;
	var engine:Engine<Event>;
	
	public function new(engine) {
		this.engine = engine;
		array = [];
	}
	
	public function add(system:System<Event>) {
		remove(system); // re-add to the end of the list
		array.push(system);
		system.onAdded(engine);
	}
	
	public function remove(system:System<Event>) {
		if(array.remove(system))
			system.onRemoved(engine);
	}
	
	public inline function iterator()
		return array.iterator();
}

class EntityCollection {
	public var added(default, null):Signal<Entity>;
	public var removed(default, null):Signal<Entity>;
	
	var allowModify:State<Bool>;
	var array:Array<Entity>;
	var addedTrigger:SignalTrigger<Entity>;
	var removedTrigger:SignalTrigger<Entity>;
	
	var pending:Array<Pair<Entity, Bool>>;
	
	public function new(allowModify:State<Bool>) {
		this.allowModify = allowModify;
		
		array = [];
		pending = [];
		added = addedTrigger = Signal.trigger();
		removed = removedTrigger = Signal.trigger();
	}
	
	public function add(entity:Entity) {
		if(allowModify.value) {
			_add(entity);
		} else {
			registerUpdate();
			pending.push(new Pair(entity, true));
		}
	}
	
	public function remove(entity:Entity) {
		if(allowModify.value) {
			_remove(entity);
		} else {
			registerUpdate();
			pending.push(new Pair(entity, false));
		}
	}
	
	inline function registerUpdate() {
		if(pending.length == 0)
			allowModify.observe().nextTime(function(v) return v).handle(update);
	}
	
	function update() {
		for(v in pending) if(v.b) _add(v.a) else _remove(v.a);
		pending = [];
	}
	
	inline function _remove(entity:Entity) {
		if(array.remove(entity))
			removedTrigger.trigger(entity);
	}
	
	inline function _add(entity:Entity) {
		remove(entity); // re-add to the end of the list
		array.push(entity);
		addedTrigger.trigger(entity);
	}
	
	public function destroy() {
		for(entity in array) entity.destroy();
		array = null;
		// TODO: destroy signals
	}
	
	public inline function iterator()
		return array.iterator();
}

class EventEmitter<Event:EnumValue> {
	var trigger:SignalTrigger<Event>;
	var postSystem:Array<Event>;
	var postUpdate:Array<Event>;
	
	public function new() {
		trigger = Signal.trigger();
		postSystem = [];
		postUpdate = [];
	}
	
	public inline function handle(f) {
		return trigger.asSignal().handle(f);
	}
	
	public inline function select(f) {
		return trigger.asSignal().select(f);
	}
	
	public inline function immediate(v:Event) {
		trigger.trigger(v);
	}
	
	public inline function afterSystem(v:Event) {
		postSystem.push(v);
	}
	
	public inline function afterUpdate(v:Event) {
		postUpdate.push(v);
	}
	
	public function flushSystem() {
		if(flush(postSystem))
			postSystem = [];
			// TODO: use this in haxe 4: postSystem.resize(0);
	}
	
	public function flushUpdate() {
		if(flush(postUpdate))
			postUpdate = [];
			// TODO: use this in haxe 4: postUpdate.resize(0);
	}
	
	inline function flush(events:Array<Event>) {
		for(e in new ConstArrayIterator(events)) trigger.trigger(e);
		return events.length > 0;
	}
}