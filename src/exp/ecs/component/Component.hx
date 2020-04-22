package exp.ecs.component;

class Component {
	public var componentType(get, never):ComponentType;
	
	inline function get_componentType():ComponentType
		return this;
		
	public inline function asProvider(?id:String)
		return new ComponentProvider.ComponentInstanceProvider(this, id);
}
