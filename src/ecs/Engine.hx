package ecs;

import ecs.entity.*;
import ecs.event.*;
import ecs.node.*;
import ecs.node.NodeList;
import ecs.system.*;
import ecs.state.*;
import ecs.util.*;
import tink.state.State;

using tink.CoreApi;

class Engine<Event> {
	
	public var entities(default, null):EntityCollection;
	public var systems(default, null):SystemCollection<Event>;
	public var events(default, null):EventEmitter<Event>;
	public var states(default, null):EngineStateMachine<Event>;
	public var delay(default, null):Delay;
	
	var nodeLists:Map<NodeType, NodeList<Dynamic>>;
	var allowModifyEntities:State<Bool>;
	
	public function new() {
		allowModifyEntities = new State(true);
		entities = new EntityCollection(allowModifyEntities);
		systems = new SystemCollection(this);
		events = new EventEmitter();
		states = new EngineStateMachine(this);
		delay = new Delay();
		nodeLists = new Map();
	}
	
	public function update(dt:Float) {
		for(system in systems) {
			allowModifyEntities.set(false);
			system.update(dt);
			allowModifyEntities.set(true);
			delay.flushSystem();
			events.flushSystem();
		}
		delay.flushUpdate();
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

class Delay {
	var postSystemUpdate:Array<Void->Void>;
	var postEngineUpdate:Array<Void->Void>;
	
	public function new() {
		postSystemUpdate = [];
		postEngineUpdate = [];
	}
	
	public inline function afterSystemUpdate(v:Void->Void) {
		postSystemUpdate.push(v);
	}
	
	public inline function afterEngineUpdate(v:Void->Void) {
		postEngineUpdate.push(v);
	}
	
	public function flushSystem() {
		if(flush(postSystemUpdate))
			postSystemUpdate = [];
			// TODO: use this in haxe 4: postSystemUpdate.resize(0);
	}
	
	public function flushUpdate() {
		if(flush(postEngineUpdate))
			postEngineUpdate = [];
			// TODO: use this in haxe 4: postEngineUpdate.resize(0);
	}
	
	function flush(calls:Array<Void->Void>) {
		for(call in new ConstArrayIterator(calls)) call();
		return calls.length > 0;
	}
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

