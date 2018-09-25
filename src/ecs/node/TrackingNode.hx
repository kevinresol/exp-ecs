package ecs.node;

import ecs.component.*;
using tink.CoreApi;

class TrackingNode extends NodeBase {
	var binding:CallbackLink;
	
	public function new(entity, ?name) {
		this.entity = entity;
		this.name = name;
		
		binding = [
			entity.componentAdded.handle(onComponentAdded),
			entity.componentRemoved.handle(onComponentRemoved),
		];
	}
	
	override function destroy() {
		super.destroy();
		binding.dissolve();
		binding = null;
	}
	
	function onComponentAdded(component:Component) {}
	function onComponentRemoved(component:Component) {}
}