package ecs;

interface Component {}

abstract ComponentType(String) to String {
	inline function new(v:String)
		this = v;
	
	@:from
	public static inline function ofClass(v:Class<Component>):ComponentType
		return new ComponentType(Type.getClassName(v));
		
	@:from
	public static inline function ofInstance(v:Component):ComponentType
		return ofClass(Type.getClass(v));
		
	@:to
	public inline function toClass():Class<Component>
		return cast Type.resolveClass(this);
}