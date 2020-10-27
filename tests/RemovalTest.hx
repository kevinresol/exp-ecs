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
		entity.add(ParentTag);
		target.add(Dummy);
		entity.link('target', target);

		var add = false;
		var link = false;
		var unlink = false;
		var added = null;
		var length = null;
		world.pipeline.add(0, System.simple('System1', ParentTag, (nodes, dt) -> {
			if (add)
				added = world.entities.create();
			if (link)
				entity.link('target', target);
			if (unlink)
				entity.unlink('target');
		}));

		world.pipeline.add(0, System.simple('System2', ParentTag && @:component(target) Linked('target', Dummy), (nodes, dt) -> length = nodes.length));

		engine.update(1 / 60);
		asserts.assert(length == 1);

		unlink = true;
		engine.update(1 / 60);
		asserts.assert(length == 1); // nodes are cached at beginning of update so it won't change here

		unlink = false;
		link = true;
		add = true;
		engine.update(1 / 60);
		asserts.assert(length == 0); // reflect unlink in last update

		add = link = false;
		unlink = true;
		engine.update(1 / 60);
		asserts.assert(length == 1); // reflect link in last update

		unlink = false;
		engine.update(1 / 60);
		asserts.assert(length == 0); // reflect unlink in last update

		return asserts.done();
	}
}

private class Dummy implements Component {}
private class ParentTag implements Component {}
