package exp.ecs.system;

@:nullSafety(Off)
class SingleListSystem<T> extends System {
	final tracker:ObservableNodeList<T>;
	var nodes:NodeList<T>;

	public function new(tracker) {
		this.tracker = tracker;
	}

	override function initialize() {
		return tracker.bind(v -> nodes = v, tink.state.Scheduler.direct);
	}
}
