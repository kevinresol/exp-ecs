package exp.ecs;

class System {
	public static macro function simple(name, world, query, f) {
		return macro new exp.ecs.system.SimpleSystem($name, exp.ecs.NodeList.generate($world, $query), $f);
	}
}
