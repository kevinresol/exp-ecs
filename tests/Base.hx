class Base {
	public function new() {}
	inline function getClassName(v:Dynamic) {
		return Type.getClassName(Type.getClass(v));
	}
}