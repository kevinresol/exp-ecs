package ecs.node;

abstract NodeType(String) to String {
	inline function new(v:String)
		this = v;
	
	@:from
	public static inline function ofClass(v:Class<NodeBase>):NodeType
		return new NodeType(Type.getClassName(v));
		
	@:from
	public static inline function ofInstance(v:NodeBase):NodeType
		return ofClass(Type.getClass(v));
		
	@:to
	public inline function toClass():Class<NodeBase>
		return cast Type.resolveClass(this);
}