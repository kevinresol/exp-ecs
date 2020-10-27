package exp.ecs.system;

@:nullSafety(Off)
class SimpleSystem<T> extends SingleListSystem<T> {
	final name:String;
	final f:(nodes:NodeList<T>, dt:Float) -> Void;

	public function new(name, spec, f) {
		super(spec);
		this.name = name;
		this.f = f;
	}

	override function update(dt:Float) {
		f(nodes, dt);
	}

	public function toString() {
		return name;
	}
}
