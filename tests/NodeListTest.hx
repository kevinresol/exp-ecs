package;

import exp.ecs.*;

@:asserts
class NodeListTest {
	public function new() {}

	public function simple() {
		final engine = new Engine();
		final world = engine.worlds.create([0]);

		final owned = NodeList.generate(world, Dummy);
		final shared = NodeList.generate(world, Shared(Dummy));
		final whatever = NodeList.generate(world, Whatever(Dummy));
		final notOwned = NodeList.generate(world, !Dummy);
		final notShared = NodeList.generate(world, !Shared(Dummy));
		final notWhatever = NodeList.generate(world, !Whatever(Dummy));

		final entity = world.entities.create();

		asserts.assert(owned.value.length == 0);
		asserts.assert(shared.value.length == 0);
		asserts.assert(whatever.value.length == 0);
		asserts.assert(notOwned.value.length == 1);
		asserts.assert(notShared.value.length == 1);
		asserts.assert(notWhatever.value.length == 1);

		entity.add(Dummy);
		asserts.assert(owned.value.length == 1);
		asserts.assert(shared.value.length == 0);
		asserts.assert(whatever.value.length == 1);
		asserts.assert(notOwned.value.length == 0);
		asserts.assert(notShared.value.length == 1);
		asserts.assert(notWhatever.value.length == 0);

		entity.remove(Dummy);
		asserts.assert(owned.value.length == 0);
		asserts.assert(shared.value.length == 0);
		asserts.assert(whatever.value.length == 0);
		asserts.assert(notOwned.value.length == 1);
		asserts.assert(notShared.value.length == 1);
		asserts.assert(notWhatever.value.length == 1);

		final entity = world.entities.create();
		asserts.assert(owned.value.length == 0);
		asserts.assert(shared.value.length == 0);
		asserts.assert(whatever.value.length == 0);
		asserts.assert(notOwned.value.length == 2);
		asserts.assert(notShared.value.length == 2);
		asserts.assert(notWhatever.value.length == 2);

		entity.add(Dummy);
		asserts.assert(owned.value.length == 1);
		asserts.assert(shared.value.length == 0);
		asserts.assert(whatever.value.length == 1);
		asserts.assert(notOwned.value.length == 1);
		asserts.assert(notShared.value.length == 2);
		asserts.assert(notWhatever.value.length == 1);

		entity.remove(Dummy);
		asserts.assert(owned.value.length == 0);
		asserts.assert(shared.value.length == 0);
		asserts.assert(whatever.value.length == 0);
		asserts.assert(notOwned.value.length == 2);
		asserts.assert(notShared.value.length == 2);
		asserts.assert(notWhatever.value.length == 2);

		return asserts.done();
	}

	public function inherited() {
		final engine = new Engine();
		final world = engine.worlds.create([0]);

		final base = world.entities.create();
		final entity = world.entities.create();
		entity.base = base;

		final owned = NodeList.generate(world, Dummy);
		final shared = NodeList.generate(world, Shared(Dummy));
		final whatever = NodeList.generate(world, Whatever(Dummy));
		final notOwned = NodeList.generate(world, !Dummy);
		final notShared = NodeList.generate(world, !Shared(Dummy));
		final notWhatever = NodeList.generate(world, !Whatever(Dummy));

		asserts.assert(owned.value.length == 0);
		asserts.assert(shared.value.length == 0);
		asserts.assert(whatever.value.length == 0);
		asserts.assert(notOwned.value.length == 2);
		asserts.assert(notShared.value.length == 2);
		asserts.assert(notWhatever.value.length == 2);

		base.add(Dummy);
		asserts.assert(owned.value.length == 1);
		asserts.assert(shared.value.length == 1);
		asserts.assert(whatever.value.length == 2);
		asserts.assert(notOwned.value.length == 1);
		asserts.assert(notShared.value.length == 1);
		asserts.assert(notWhatever.value.length == 0);

		entity.add(Dummy);
		asserts.assert(owned.value.length == 2);
		asserts.assert(shared.value.length == 0);
		asserts.assert(whatever.value.length == 2);
		asserts.assert(notOwned.value.length == 0);
		asserts.assert(notShared.value.length == 2);
		asserts.assert(notWhatever.value.length == 0);

		base.remove(Dummy);
		asserts.assert(owned.value.length == 1);
		asserts.assert(shared.value.length == 0);
		asserts.assert(whatever.value.length == 1);
		asserts.assert(notOwned.value.length == 1);
		asserts.assert(notShared.value.length == 2);
		asserts.assert(notWhatever.value.length == 1);

		return asserts.done();
	}

	public function linked() {
		final engine = new Engine();
		final world = engine.worlds.create([0]);

		final entity = world.entities.create();
		final target = world.entities.create();
		entity.link('target', target);

		final linked = NodeList.generate(world, Linked('target', Dummy));

		asserts.assert(linked.value.length == 0);

		target.add(Dummy);
		asserts.assert(linked.value.length == 1);

		target.remove(Dummy);
		asserts.assert(linked.value.length == 0);

		target.add(Dummy);
		asserts.assert(linked.value.length == 1);

		entity.unlink('target');
		asserts.assert(linked.value.length == 0);

		entity.link('target', target);
		asserts.assert(linked.value.length == 1);

		return asserts.done();
	}

	public function linkedParent() {
		final engine = new Engine();
		final world = engine.worlds.create([0]);

		final entity = world.entities.create();
		final target = world.entities.create();
		final parent = world.entities.create();
		entity.link('target', target);
		target.parent = parent;

		final list = NodeList.generate(world, @:entity(parent2) Linked('target', Parent(Dummy)));

		asserts.assert(list.value.length == 0);

		parent.add(Dummy);
		asserts.assert(list.value.length == 1);
		asserts.assert(list.value.get(0).data.parent2 == parent);

		parent.remove(Dummy);
		asserts.assert(list.value.length == 0);

		parent.add(Dummy);
		asserts.assert(list.value.length == 1);

		entity.unlink('target');
		asserts.assert(list.value.length == 0);

		entity.link('target', target);
		asserts.assert(list.value.length == 1);

		return asserts.done();
	}
}

class Dummy implements Component {}
