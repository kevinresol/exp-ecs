package system;

import component.*;
import ecs.system.*;
import ecs.node.*;
import ecs.event.*;
import ecs.entity.*;
import util.*;
using tink.CoreApi;

class CollisionSystem<Event:EnumValue> extends System<Event> {
	@:nodes var nodes:Node<Position, Collision>;
	
	var factory:Factory<Event, Pair<Entity, Entity>>;
	
	public function new(factory) {
		super();
		this.factory = factory;
	}
	
	override function update(dt:Float) {
		var arr = @:privateAccess nodes.nodes; // TODO: expose as ReadOnlyArray in NodeList
		
		for(i in 0...arr.length) for(j in i+1...arr.length) {
			var n1 = arr[i];
			var n2 = arr[j];
			if(match(n1.collision.groups, n2.collision.groups)) {
				if(Point.distance(n1.position.position, n2.position.position) < n1.collision.radius + n2.collision.radius) {
					engine.events.trigger(factory(new Pair(n1.entity, n2.entity)));
				}
			}
		}
	}
	
	function match(g1:Array<Int>, g2:Array<Int>) {
		for(v in g1) if(g2.indexOf(v) != -1) return true;
		return false;
	}
}
