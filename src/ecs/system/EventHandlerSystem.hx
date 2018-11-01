package ecs.system;

import ecs.event.*;
using tink.CoreApi;

class EventHandlerSystem<Event:EnumValue, Data> extends System<Event> {
	
	var selector:Selector<Event, Data>;
	var handler:Callback<Data>;
	var binding:CallbackLink;
	
	public function new(selector, handler) {
		super();
		this.selector = selector;
		this.handler = handler;
	}
	
	override function onAdded(engine) {
		super.onAdded(engine);
		binding = engine.events.select(selector).handle(handler);
	}
	
	override function onRemoved(engine) {
		super.onRemoved(engine);
		binding.dissolve();
	}
}
