package exp.ecs.system;

class FixedUpdateSystem<Event> extends System<Event> {
	
	var delta:Float;
	var residue:Float = 0;
	
	public function new(delta = 0.01) {
		super();
		this.delta = delta;
	}
	
	override function update(dt:Float) {
		residue += dt;
		while(residue > delta) {
			fixedUpdate(delta);
			residue -= delta;
		}
	}
	
	function fixedUpdate(dt:Float) {}
}
