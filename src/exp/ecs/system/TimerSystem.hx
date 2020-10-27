package exp.ecs.system;

class TimerSystem extends System {
	final interval:Float = 0;
	final f:Void->Void;
	var current:Float;

	public function new(interval, f) {
		this.interval = current = interval;
		this.f = f;
	}

	override function update(dt:Float) {
		if ((current -= dt) <= 0) {
			f();
			current += interval;
		}
	}
}
