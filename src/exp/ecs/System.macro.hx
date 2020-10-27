package exp.ecs;

class System {
	public static macro function simple(name, query, f) {
		return macro new exp.ecs.system.SimpleSystem($name, exp.ecs.NodeList.spec($query), $f);
	}
}
