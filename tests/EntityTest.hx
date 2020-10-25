package;

import exp.ecs.*;

@:asserts
class EntityTest {
	public function new() {}

	public function simple() {
		final engine = new Engine();
		final world = engine.worlds.create([0]);
		final entity = world.entities.create();

		entity.add(Foo);
		asserts.assert(entity.has(Foo));

		return asserts.done();
	}
}

class Foo implements Component {}
