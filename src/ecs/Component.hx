package ecs;

interface Component {}

abstract ComponentType(String) {
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
		
	@:to
	public inline function toString():String
		return this;
}

@:forward
abstract ComponentProvider(ComponentProviderObject) from ComponentProviderObject to ComponentProviderObject {
	@:from
	public static inline function ofComponent(v:Component):ComponentProvider {
		return new ComponentInstanceProvider(v);
	}
}

class ComponentInstanceProvider implements ComponentProviderObject {
	var component:Component;
	var id:String;
	
	public function new(component, ?id) {
		this.component = component;
		this.id = id == null ? (component:ComponentType) : id;
	}
		
	public function get()
		return component;
		
	public function identifier():String
		return id;
}

interface ComponentProviderObject {
	function get():Component;
	function identifier():String;
}