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
	
	public function new() {
		entities = new EntityCollection();
		systems = new SystemCollection(this);
		events = new EventEmitter();
		states = new EngineStateMachine(this);
		delay = new Delay();
		nodeLists = new Map();
	}
	
	public function update(dt:Float) {
		systems.lock();
		for(system in systems) {
			entities.lock();
			system.update(dt);
			entities.unlock();
			delay.flushSystem();
			events.flushSystem();
		}
		systems.unlock();
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
		
		systems.destroy();
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

