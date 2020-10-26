package;

import exp.ecs.*;

@:asserts
class RemovalTest {
	public function new() {}

	public function removeLinkage() {
		final engine = new Engine();
		final world = engine.worlds.create([0]);

		final entity = world.entities.create();
		final target = world.entities.create();
		entity.add(Dummy);
		target.add(Dummy);
		entity.link('target', target);

		var unlink = false;
		var length = null;
		world.pipeline.add(0,
			System.simple('System1', world, Dummy && @:component(target) Linked('target', Dummy), (nodes, dt) -> if (unlink) entity.unlink('target')));
		world.pipeline.add(0, System.simple('System2', world, Dummy && @:component(target) Linked('target', Dummy), (nodes, dt) -> length = nodes.length));

		engine.update(1 / 60);
		asserts.assert(length == 1);

		unlink = true;
		engine.update(1 / 60);
		asserts.assert(length == 1); // nodes are cached at beginning of update so it won't change here

		unlink = false;
		engine.update(1 / 60);
		asserts.assert(length == 0); // on next update it is changed

		return asserts.done();
	}
}

private class Dummy implements Component {}
