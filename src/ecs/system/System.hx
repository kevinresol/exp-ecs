package ecs.system;

import ecs.*;
import ecs.node.*;
using tink.CoreApi;

class System {
	var engine:Engine;
	
	public function new() {}
	
	public function update(dt:Float) {}
	
	public function onAdded(engine:Engine)
		this.engine = engine;
	
	public function onRemoved(engine:Engine)
		engine = null;
	
	public function toString()
		return Type.getClassName(Type.getClass(this));
}