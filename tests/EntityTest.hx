package;

import exp.ecs.*;

@:asserts
class EntityTest {
	public function new() {}

	public function simple() {
		final engine = new Engine();
		final world = engine.worlds.create([0]);
		final entity = world.entities.create();
		final foo = new Foo();

		entity.add(foo);
		asserts.assert(entity.get(Foo) == foo);

		return asserts.done();
	}
}

class Foo implements Component {}
