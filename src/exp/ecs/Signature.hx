package exp.ecs;

abstract Signature(String) {
	inline function new(v:String)
		this = v;

	// @:from
	// public static inline function ofClass(v:Class<Component>):Signature
	// 	return new Signature(Type.getClassName(v));

	@:from
	public static inline function ofInstance(v:Component):Signature
		return v.signature;

	@:from
	public static macro function ofExpr(e);

	@:to
	public inline function toString():String
		return this;
}
