package exp.ecs;

import exp.ecs.Entity;
import tink.state.Observable;
import tink.state.ObservableMap;

using tink.CoreApi;

@:allow(exp.ecs)
class World {
	public final id:Int;
	public final entities:EntityCollection;
	public final pipeline:Pipeline;
	public var speed:Float = 1;

	function new(id, phases) {
		this.id = id;
		this.entities = new EntityCollection(@:nullSafety(Off) this);
		this.pipeline = new Pipeline(this, phases);
	}

	inline function update(dt:Float) {
		pipeline.update(dt * speed);
	}
}

@:allow(exp.ecs)
class EntityCollection {
	static var ids:Int = 0;

	// public final singleton:Entity;
	final world:World;
	final map:GranularMap<Int, Entity> = new GranularMap([]);

	function new(world) {
		this.world = world;
		// this.singleton = new Entity(ids++); // it is not added to the entity map so it can't be queried, but only be explicitly referenced
	}

	public function create() {
		var entity = new Entity(ids++);
		map.set(entity.id, entity);
		return entity;
	}

	public inline function spawn(prefab:Prefab) {
		return prefab.spawn(world);
	}

	public function remove(id:Int) {
		switch map.get(id) {
			case null:
			case entity:
				map.remove(id);
				entity.setRemoved();
		}
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

	public function query(q:Query):Observable<Array<Entity>> {
		final entityQueries = {
			final cache = new Map<Int, Pair<Entity, Observable<Bool>>>();
			Observable.auto(() -> {
				for (id => entity in map)
					if (!cache.exists(id))
						cache.set(id, new Pair(entity, Observable.auto(() -> entity.fulfills(q), null, id -> 'World:${entity.toString()}:fulfills#$id')));

				final deleted = [for (id in cache.keys()) if (!map.exists(id)) id];

				for (id in deleted)
					cache.remove(id);

				cache;
			},
				(_, _) -> false, // we're always returning the same map, so the comparator must always yield false
				id -> 'World:cache#$id');
		}

		return Observable.auto(() -> [for (p in entityQueries.value) if (p.b) p.a], null, id -> 'World:root#$id');
	}

	public inline function count() {
		return Lambda.count(map);
	}

	// public function observe(q:Query):Observable<Array<Entity>> {
	// 	return Observable.auto(() -> [for (entity in map) if (entity.observe(q)) entity]);
	// }
}
