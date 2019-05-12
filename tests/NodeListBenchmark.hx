package;

import Types;
import exp.ecs.Engine;
import exp.ecs.entity.*;
import exp.ecs.node.*;
import exp.ecs.*;
import tink.unit.*;

using tink.CoreApi;

class NodeListBenchmark implements Benchmark {
	
	var list:NodeList<MovementNode>;
	
	public function new() {}
	
	@:before
	public function before() {
		var engine = new Engine();
		for(i in 0...1000) {
			var entity = new Entity();
			entity.add(new Velocity(0, 0));
			entity.add(new Position(0, 0));
			engine.entities.add(entity);
		}
		list = engine.getNodeList(MovementNode, MovementNode.createNodeList);
		return Noise;
	}
	
	@:benchmark(10000)
	public function iterate() {
		for(node in list) {
			var pos = node.position;
			var vel = node.velocity;
			pos.x += vel.x;
			pos.y += vel.y;
		}
	}
}


