package exp.ecs.component;

class Component {
	public var type(get, never):ComponentType;
	
	inline function get_type():ComponentType
		return this;
		
	public inline function asProvider(?id:String)
		return new ComponentProvider.ComponentInstanceProvider(this, id);
}
