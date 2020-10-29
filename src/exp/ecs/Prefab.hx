package exp.ecs;

@:allow(exp.ecs)
class Prefab extends Object<Prefab> {
	static var ids:Int = 0;

	public function new() {
		super(ids++, 'Prefab');
	}

	public function spawn(world:World):Entity {
		final entity = world.entities.create();

		for (prefab in derived)
			prefab.spawn(world).base = entity;

		for (prefab in children)
			prefab.spawn(world).parent = entity;

		for (component in components)
			entity.addComponent(component.clone());

		return entity;
	}
}
