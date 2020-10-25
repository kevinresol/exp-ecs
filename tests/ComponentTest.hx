package;

import exp.ecs.*;

@:asserts
class ComponentTest {
	public function new() {}
	
	public function optionals() {
		final v = new C1(2);
		asserts.assert(v.i == 2);
		asserts.assert(v.oi == 42);
		final v = new C1(42, 7);
		asserts.assert(v.i == 42);
		asserts.assert(v.oi == 7);
		return asserts.done();
	}
}

private class C1 implements Component {
	public var i:Int;
	public var oi:Int = 42;
}