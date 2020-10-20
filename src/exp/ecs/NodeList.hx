package exp.ecs;

import tink.state.Observable;

using Lambda;

class NodeList<T> {
	public var length(get, never):Int;

	final list:Observable<Array<Node<T>>>;

	public function new(list) {
		this.list = list;
	}

	public static inline function make<T>(world:World, query:Query, fetchComponents:Entity->T) {
		return new NodeList({
			final cache = new Map();
			final entities = world.entities.query(query);
			final nodes = Observable.auto(() -> {
				final entities = entities.value;
				for (entity in entities) {
					if (!cache.exists(entity.id))
						cache.set(entity.id, Observable.auto(() -> new Node(entity, fetchComponents(entity))));
				}

				var deleted = [for (id in cache.keys()) if (!entities.exists(e -> e.id == id)) id];

				for (id in deleted)
					cache.remove(id);

				cache;
			}, (_, _) -> false);
			Observable.auto(() -> [for (node in nodes.value) node.value]);
		});
	}

	public inline function iterator() {
		return list.value.iterator();
	}

	inline function get_length()
		return list.value.length;

	public static macro function generate(e);
}

enum Hierarchy {
	Parent;
	Linked(key:String);
}