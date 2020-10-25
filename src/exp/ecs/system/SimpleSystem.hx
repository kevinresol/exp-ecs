package exp.ecs.system;

@:nullSafety(Off)
class SimpleSystem<T> extends System {
	final name:String;
	final f:(nodes:NodeList<T>, dt:Float) -> Void;
	final tracker:ObservableNodeList<T>;
	var nodes:NodeList<T>;

	public function new(name, tracker, f) {
		this.name = name;
		this.tracker = tracker;
		this.f = f;
	}

	override function initialize() {
		return tracker.bind(v -> nodes = v, tink.state.Scheduler.direct);
	}

	override function update(dt:Float) {
		f(nodes, dt);
	}

	public function toString() {
		return name;
	}
}
