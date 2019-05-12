import Types;

import exp.ecs.Engine;
import exp.ecs.entity.*;
import exp.ecs.system.*;
import tink.unit.*;

using tink.CoreApi;

class EngineBenchmark implements Benchmark {
	
	var engine:Engine<Events> = new Engine();
	
	public function new() {}
	
	@:setup
	public function setup() {
		engine = new Engine();
		return Noise;
	}
	
	@:benchmark(10000)
	public function addEntity() {
		var entity = new Entity();
		engine.entities.add(entity);
	}
	
	@:benchmark(10000)
	public function addSystem() {
		var system = new System();
		engine.systems.add(system);
	}
	
	@:teardown
	public function teardown() {
		engine.destroy();
		engine = null;
		return Noise;
	}
}