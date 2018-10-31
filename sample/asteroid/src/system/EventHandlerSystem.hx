package system;

import component.*;
import ecs.system.*;
import ecs.node.*;
import ecs.event.*;
import ecs.entity.*;
import util.*;
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
