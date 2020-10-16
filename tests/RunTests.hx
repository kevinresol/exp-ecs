package;

import exp.ecs.*;

class RunTests {
	static function main() {
		final engine = new Engine();
		final world = engine.worlds.create();
		// final entity = world.entities.create();

		final prefab = new Prefab();
		prefab.add(new Position(1, 1));
		prefab.add(new exp.ecs.component.Name('Wow'));
		trace(prefab.toString());
		final entity = world.entities.spawn(prefab);
		trace(TransformSystem);
		trace(entity.toString());
	}
}

class TransformSystem extends System {
	@:keep final nodes = NodeList.generate(foo.Bar && Speed && (Position || ~Velocity));
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
