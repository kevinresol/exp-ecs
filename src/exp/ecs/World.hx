package exp.ecs;

import exp.ecs.Entity;

@:allow(exp.ecs)
class World {
	public final id:Int;
	public final entities:EntityCollection;

	function new(id) {
		this.id = id;
		this.entities = new EntityCollection(this);
	}
}

@:allow(exp.ecs)
class EntityCollection {
	static var ids:Int = 0;

	final world:World;
	final map:Map<Int, Entity> = [];

	function new(world) {
		this.world = world;
	}

	public function create() {
		var entity = new Entity(ids++);
		map.set(entity.id, entity);
		return entity;
	}

	public inline function spawn(prefab:Prefab) {
		return prefab.spawn(world);
	}

	public inline function get(id:Int) {
		return map.get(id);
	}

	public function lookup(name:String):Null<Entity> {
		for (entity in map)
			switch entity.get(exp.ecs.component.Name) {
				case null: // continue
				case v:
					if (v.value == name)
						return entity;
			}
		return null;
	}

	public function query(q:Query):Array<Entity> {
		return [for (entity in map) if (entity.fulfills(q)) entity];
	}
}
