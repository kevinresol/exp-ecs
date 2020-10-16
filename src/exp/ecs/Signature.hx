package exp.ecs;

abstract Signature(String) {
	inline function new(v:String)
		this = v;

	@:from
	public static inline function ofClass(v:Class<Component>):Signature
		return new Signature(Type.getClassName(v));

	@:from
	public static inline function ofInstance(v:Component):Signature
		return ofClass(@:nullSafety(Off) Type.getClass(v));

	@:to
	public inline function toClass():Class<Component>
		return cast Type.resolveClass(this);

	@:to
	public inline function toString():String
		return this;
}
