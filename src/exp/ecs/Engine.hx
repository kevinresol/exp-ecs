package exp.ecs;

import exp.ecs.entity.*;
import exp.ecs.event.*;
import exp.ecs.node.*;
import exp.ecs.node.NodeList;
import exp.ecs.system.*;
import exp.ecs.state.*;
import exp.ecs.util.*;
import exp.fsm.*;
import tink.state.State;

using tink.CoreApi;

class Engine<Event> {
	
	public var entities(default, null):EntityCollection;
	public var systems(default, null):SystemCollection<Event>;
	public var events(default, null):EventEmitter<Event>;
	public var delay(default, null):Delay<Event>;
	
	public var systemUpdated(default, null):Signal<System<Event>>;
	public var updated(default, null):Signal<Noise>;
	
	var nodeLists:Map<NodeType, NodeList<Dynamic>>;
	var systemUpdatedTrigger:SignalTrigger<System<Event>>;
	var updatedTrigger:SignalTrigger<Noise>;
	
	public function new() {
		systemUpdated = systemUpdatedTrigger = Signal.trigger();
		updated = updatedTrigger = Signal.trigger();
		entities = new EntityCollection();
		systems = new SystemCollection(this);
		events = new EventEmitter(this);
		delay = new Delay(this);
		nodeLists = new Map();
	}
	
	public function update(dt:Float) {
		systems.lock();
		for(system in systems) {
			entities.lock();
			system.update(dt);
			entities.unlock();
			systemUpdatedTrigger.trigger(system);
		}
		systems.unlock();
		updatedTrigger.trigger(Noise);
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

class Delay<Event> {
	var postSystemUpdate:Array<Void->Void>;
	var postEngineUpdate:Array<Void->Void>;
	var engine:Engine<Event>;
	
	public function new(engine) {
		this.engine = engine;
		postSystemUpdate = [];
		postEngineUpdate = [];
		engine.systemUpdated.handle(function(_) flushSystem());
		engine.updated.handle(function(_) flushUpdate());
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

