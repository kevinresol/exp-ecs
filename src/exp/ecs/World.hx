package exp.ecs;

import exp.ecs.Entity;
import tink.state.Observable;
import tink.state.ObservableMap;

@:allow(exp.ecs)
class World {
	public final id:Int;
	public final entities:EntityCollection;
	public final pipeline:Pipeline;

	function new(id, phases) {
		this.id = id;
		this.entities = new EntityCollection(@:nullSafety(Off) this);
		this.pipeline = new Pipeline(this, phases);
	}

	inline function update(dt:Float) {
		pipeline.update(dt);
	}
}

@:allow(exp.ecs)
class EntityCollection {
	static var ids:Int = 0;

	final world:World;
	final map:ObservableMap<Int, Entity> = new ObservableMap([]);

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

	public function observe(q:Query):Observable<Array<Entity>> {
		return Observable.auto(() -> [for (entity in map) if (entity.observe(q)) entity]);
	}
}
