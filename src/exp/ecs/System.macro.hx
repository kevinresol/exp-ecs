package exp.ecs;

class System {
	public static macro function single(name, query, f) {
		return macro new exp.ecs.system.SimpleSingleListSystem($name, exp.ecs.NodeList.spec($query), $f);
	}
}
