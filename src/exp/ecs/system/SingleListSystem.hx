package exp.ecs.system;

import exp.ecs.NodeList;

@:nullSafety(Off)
class SingleListSystem<T> extends System {
	final spec:NodeListSpec<T>;
	var nodes:NodeList<T>;

	public function new(spec) {
		this.spec = spec;
	}

	override function initialize(world:World) {
		return NodeList.make(world, spec).bind(v -> nodes = v, tink.state.Scheduler.direct);
	}
}
