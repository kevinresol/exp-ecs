package ecs.component;

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