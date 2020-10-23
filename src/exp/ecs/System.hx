package exp.ecs;

@:allow(exp.ecs)
class System {
	function update(dt:Float) {}

	public static macro function simple(name, world, query, f);
}
