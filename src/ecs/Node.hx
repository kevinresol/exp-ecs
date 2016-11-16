package ecs;

#if !macro @:genericBuild(ecs.Macro.buildNode()) #end
class Node<Rest> {}

// TODO: find something else to back a NodeList, because ObjectMap is pretty slow on iterating
abstract NodeList<T>(Map<Entity, T>) from Map<Entity, T> to Map<Entity, T> {
	public inline function new() this = new Map();
	
	public inline function add(entity:Entity, node:T) this.set(entity, node);
	public inline function removeEntity(entity:Entity) this.remove(entity);
	public inline function iterator() return this.iterator();
}

interface NodeBase {}

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