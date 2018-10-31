package system;

import component.*;
import ecs.system.*;
import ecs.node.*;
import ecs.event.*;
import ecs.entity.*;
import util.*;
using tink.CoreApi;

class CollisionResultSystem<Event:EnumValue> extends System<Event> {
	
	var selector:Selector<Event, Pair<Entity, Entity>>;
	var handler:Callback<Pair<Entity, Entity>>;
	var binding:CallbackLink;
	
	public function new(selector, handler) {
		super();
		this.selector = selector;
		this.handler = handler;
	}
	
	override function onAdded(engine) {
		super.onAdded(engine);
		binding = engine.events.asSignal().select(selector).handle(data -> Callback.defer(handler.invoke.bind(data)));
	}
	
	override function onRemoved(engine) {
		super.onRemoved(engine);
		binding.dissolve();
	}
}
