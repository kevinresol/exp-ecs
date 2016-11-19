package ecs.component;

class Component {
	public inline function asProvider(?id:String)
		return new ComponentProvider.ComponentInstanceProvider(this, id);
}
