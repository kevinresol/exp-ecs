package system;

import component.*;
import exp.ecs.system.*;
import exp.ecs.node.*;
import exp.ecs.event.*;
import exp.ecs.entity.*;
import util.*;
using tink.CoreApi;

class CollisionSystem<Event> extends System<Event> {
	@:nodes var nodes:Node<Position, Collision>;
	
	var factory:EventFactory<Event, {entity1:Entity, entity2:Entity, group1:Int, group2:Int}>;
	
	public function new(factory) {
		super();
		this.factory = factory;
	}
	
	override function update(dt:Float) {
		var arr = nodes.nodes;
		
		for(i in 0...arr.length) for(j in i+1...arr.length) {
			var n1 = arr[i];
			var n2 = arr[j];
			if(match(n1.collision, n2.collision)) {
				if(Point.distance(n1.position.position, n2.position.position) < n1.collision.radius + n2.collision.radius) {
					engine.events.afterSystemUpdate(factory({
						entity1: n1.entity,
						entity2: n2.entity,
						group1: n1.collision.group,
						group2: n2.collision.group,
					}));
				}
			}
		}
	}
	
	function match(c1:Collision, c2:Collision) {
		return c2.with.indexOf(c1.group) != -1 && c1.with.indexOf(c2.group) != -1;
	}
}
