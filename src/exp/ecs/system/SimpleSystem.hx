package exp.ecs.system;

@:nullSafety(Off)
class SimpleSystem<T> extends System {
	final name:String;
	final f:(nodes:Array<Node<T>>, dt:Float) -> Void;
	var nodes:Array<Node<T>>;

	public function new(name, nodes:NodeList<T>, f) {
		this.name = name;
		this.f = f;
		nodes.bind(v -> this.nodes = v, tink.state.Scheduler.direct);
	}

	override function update(dt:Float) {
		f(nodes, dt);
	}

	public function toString() {
		return name;
	}
}
