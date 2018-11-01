package ecs.system;

import ecs.event.*;
using tink.CoreApi;

class EventHandlerSystem<Event:EnumValue, Data> extends System<Event> {
	
	var binding:CallbackLink;
	
	function select(event:Event):Option<Data>
		return None;
	
	function handle(data:Data) {}
	
	override function onAdded(engine) {
		super.onAdded(engine);
		binding = engine.events.select(select).handle(handle);
	}
	
	override function onRemoved(engine) {
		super.onRemoved(engine);
		binding.dissolve();
	}
}

class SimpleEventHandlerSystem<Event:EnumValue, Data> extends EventHandlerSystem<Event, Data> {
	
	var selector:Selector<Event, Data>;
	var handler:Callback<Data>;
	
	public function new(selector, handler) {
		super();
		this.selector = selector;
		this.handler = handler;
	}
	
	override function select(event:Event):Option<Data>
		return selector(event);
	
	override function handle(data:Data) {
		handler.invoke(data);
	}
}
