package;

import exp.ecs.*;

class RunTests {
	static function main() {
		final engine = new Engine();
		final world = engine.worlds.create([PreUpdate, Update, PostUpdate]);
		// final entity = world.entities.create();

		// world.entities.query(Must(Owned, Velocity)).bind(list -> trace('q1:' + list.map(e -> e.toString())), tink.state.Scheduler.direct);
		// world.entities.query(Must(Owned, foo.Bar)).bind(list -> trace('q2:' + list.map(e -> e.toString())), tink.state.Scheduler.direct);

		final prefab = new Prefab();
		prefab.add(new Position(1, 1));
		// prefab.add(new exp.ecs.component.Name('Wow'));
		// trace(prefab.toString());
		final entity0 = world.entities.spawn(prefab);
		final entity1 = world.entities.spawn(prefab);
		// trace(TransformSystem);
		// trace(entity.toString());
		// tink.state.Observable.updateAll();

		trace('add');
		entity0.add(new Velocity(2, 2));
		// tink.state.Observable.updateAll();

		trace('remove');
		entity0.remove(Velocity);
		// tink.state.Observable.updateAll();

		world.pipeline.add(PreUpdate, new TransformSystem(world));

		engine.update(0.1);
		entity0.remove(Position);
		entity1.remove(Position);
		engine.update(0.1);
		entity0.add(new Position(1, 0));
		engine.update(0.1);
		entity0.remove(Position);
		engine.update(0.1);
		entity0.add(new Position(1, 0));
		entity1.add(new Position(1, 0));
		engine.update(0.1);
	}
}

enum abstract Phase(Int) to Int {
	var PreUpdate;
	var Update;
	var PostUpdate;
}

class TransformSystem extends System {
	final nodes:NodeList<{final position:Position;}>;

	public function new(world:World) {
		nodes = NodeList.generate(world, Position);
	}

	override function update(dt:Float) {
		trace(nodes.length);
	}
}

class Speed implements Component {
	public var value:Float;
}

class Position implements Component {
	public var x:Float;
	public var y:Float;
}

class Velocity implements Component {
	public var x:Float;
	public var y:Float;
}
