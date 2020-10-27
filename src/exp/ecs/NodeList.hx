package exp.ecs;

import exp.ecs.util.ConstArrayIterator;
import tink.state.Observable;

using Lambda;

class NodeListSpec<T> {
	public final query:Query;
	public final fetchComponents:Entity->T;

	public function new(query, fetchComponents) {
		this.query = query;
		this.fetchComponents = fetchComponents;
	}
}

@:forward(length, map)
abstract NodeList<T>(Array<Node<T>>) from Array<Node<T>> {
	inline function new(list) {
		this = list;
	}

	public static inline function make<T>(world:World, spec:NodeListSpec<T>):Observable<NodeList<T>> {
		final query = spec.query;
		final fetchComponents = spec.fetchComponents;
		final cache:Map<Int, Observable<Node<T>>> = new Map();
		final entities = world.entities.query(query);
		var nodes = Observable.auto(() -> {
			final entities = entities.value;
			for (entity in entities)
				if (!cache.exists(entity.id))
					cache.set(entity.id,
						Observable.auto(() -> new Node(entity, fetchComponents(entity)), null, id -> 'NodeList:${entity.toString()}:components#$id'));

			var deleted = [for (id in cache.keys()) if (!entities.exists(e -> e.id == id)) id];

			for (id in deleted)
				cache.remove(id);

			cache;
		}, (_, _) -> false, id -> 'NodeList:cache#$id');
		return Observable.auto(() -> new NodeList([for (node in nodes.value) node.value]), null, id -> 'NodeList:root#$id');
	}

	public inline function get(i) {
		return this[i];
	}

	public inline function iterator() {
		return new ConstArrayIterator(this);
	}

	public static macro function generate(world, query);

	public static macro function spec(query);
}

enum Hierarchy {
	Parent;
	Linked(key:String);
}
