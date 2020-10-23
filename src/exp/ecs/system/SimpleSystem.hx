package exp.ecs.system;

@:nullSafety(Off)
class SimpleSystem<T> extends System {
	final name:String;
	final f:(nodes:Array<Node<T>>, dt:Float) -> Void;

	var list:NodeList<T>;
	var nodes:Array<Node<T>>;

	public function new(name, list, f) {
		this.name = name;
		this.list = list;
		this.f = f;
	}

	override function initialize() {
		return list.bind(v -> nodes = v, tink.state.Scheduler.direct);
	}

	override function update(dt:Float) {
		f(nodes, dt);
	}

	public function toString() {
		return name;
	}
}
