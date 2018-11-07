package ecs.system;

abstract SystemId(String) from String to String {
	@:from
	public static function fromInstance<Event>(system:System<Event>):SystemId
		return system == null ? null : Type.getClassName(Type.getClass(system));
		
	@:from
	public static function fromClass<Event>(cls:Class<System<Event>>):SystemId
		return cls == null ? null : Type.getClassName(cls);
}