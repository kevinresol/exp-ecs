package ecs.event;

import ecs.util.*;
using tink.CoreApi;

class EventEmitter<Event> {
	var trigger:SignalTrigger<Event>;
	var postSystemUpdate:Array<Event>;
	var postEngineUpdate:Array<Event>;
	
	public function new() {
		trigger = Signal.trigger();
		postSystemUpdate = [];
		postEngineUpdate = [];
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
	
	public inline function afterSystemUpdate(v:Event) {
		postSystemUpdate.push(v);
	}
	
	public inline function afterEngineUpdate(v:Event) {
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
	
	inline function flush(events:Array<Event>) {
		for(e in new ConstArrayIterator(events)) trigger.trigger(e);
		return events.length > 0;
	}
}