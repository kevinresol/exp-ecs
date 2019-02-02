package ecs.event;

import ecs.util.*;
using tink.CoreApi;

@:allow(ecs)
class EventEmitter<Event> {
	var trigger:SignalTrigger<Event>;
	var postSystemUpdate:Array<Event>;
	var postEngineUpdate:Array<Event>;
	
	function new() {
		trigger = Signal.trigger();
		postSystemUpdate = [];
		postEngineUpdate = [];
	}
	
	/**
	 * Register a callback that will be invoked for each event emitted
	 * @param f
	 */
	public inline function handle(f) {
		return trigger.asSignal().handle(f);
	}
	
	/**
	 * Create a filtered and transformed Signal.
	 * @param f A filter+transform function. Return `None` to discard an event. Returning `Some(data)` will cause the resulting Signal to emit `data`.
	 */
	public inline function select(f) {
		return trigger.asSignal().select(f);
	}
	
	/**
	 * Emit an event immediately
	 * @param v 
	 */
	public inline function immediate(v:Event) {
		trigger.trigger(v);
	}
	
	/**
	 * Emit an event after the current running System finishes its current `update`
	 * @param v 
	 */
	public inline function afterSystemUpdate(v:Event) {
		postSystemUpdate.push(v);
	}
	
	/**
	 * Emit an event after the Engine finishes its current `update`
	 * @param v 
	 */
	public inline function afterEngineUpdate(v:Event) {
		postEngineUpdate.push(v);
	}
	
	function flushSystem() {
		if(flush(postSystemUpdate))
			postSystemUpdate = [];
			// TODO: use this in haxe 4: postSystemUpdate.resize(0);
	}
	
	function flushUpdate() {
		if(flush(postEngineUpdate))
			postEngineUpdate = [];
			// TODO: use this in haxe 4: postEngineUpdate.resize(0);
	}
	
	inline function flush(events:Array<Event>) {
		for(e in new ConstArrayIterator(events)) trigger.trigger(e);
		return events.length > 0;
	}
}