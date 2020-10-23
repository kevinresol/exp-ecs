package exp.ecs;

import tink.state.Observable;

using Lambda;

@:forward
abstract NodeList<T>(Observable<Array<Node<T>>>) {
	public var length(get, never):Int;

	inline function new(list) {
		this = list;
	}

	public static inline function make<T>(world:World, query:Query, fetchComponents:Entity->T) {
		return new NodeList({
			final cache = new Map();
			final entities = world.entities.query(query);
			final nodes = Observable.auto(() -> {
				final entities = entities.value;
				for (entity in entities) {
					if (!cache.exists(entity.id))
						cache.set(entity.id,
							Observable.auto(() -> new Node(entity, fetchComponents(entity)), null, id -> 'NodeList:${entity.toString()}:components#$id'));
				}

				var deleted = [for (id in cache.keys()) if (!entities.exists(e -> e.id == id)) id];

				for (id in deleted)
					cache.remove(id);

				cache;
			}, (_, _) -> false, id -> 'NodeList:cache#$id');
			Observable.auto(() -> [for (node in nodes.value) node.value], null, id -> 'NodeList:root#$id');
		});
	}

	@:arrayAccess
	public inline function get(v:Int) {
		return this.value[v];
	}

	public inline function iterator() {
		return this.value.iterator();
	}

	inline function get_length() {
		return this.value.length;
	}

	public static macro function generate(e);
}

enum Hierarchy {
	Parent;
	Linked(key:String);
}
