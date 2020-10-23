package exp.ecs;

@:allow(exp.ecs)
class Prefab extends Object<Prefab> {
	static var ids:Int = 0;

	public function new() {
		super(ids++, 'Prefab');
	}

	public function spawn(world:World):Entity {
		final entity = world.entities.create();

		switch base {
			case null:
			case base:
				entity.base = base.spawn(world);
		}

		for (prefab in derived)
			prefab.spawn(world).base = entity;

		switch parent {
			case null:
			case parent:
				entity.parent = parent.spawn(world);
		}

		for (prefab in children)
			prefab.spawn(world).parent = entity;

		for (component in components)
			entity.add(component.clone());

		return entity;
	}
}
