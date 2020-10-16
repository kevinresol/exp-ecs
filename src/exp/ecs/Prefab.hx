package exp.ecs;

@:allow(exp.ecs)
class Prefab extends Object<Prefab> {
	static var ids:Int = 0;

	public function new() {
		super(ids++, 'Prefab');
	}

	function spawn(world:World):Entity {
		final entity = world.entities.create();
		if (base != null)
			entity.base = base.spawn(world);
		for (prefab in derived)
			entity.derived.push(prefab.spawn(world));
		if (parent != null)
			entity.parent = parent.spawn(world);
		for (prefab in children)
			entity.children.push(prefab.spawn(world));
		for (component in components)
			entity.add(component.clone());
		return entity;
	}
}
