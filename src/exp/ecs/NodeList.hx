package exp.ecs;

import tink.state.Observable;

class NodeList<T> {
	public var length(get, never):Int;

	final query:Query;
	final fetchComponents:Entity->T;
	final list:Observable<Array<Node<T>>>;

	public function new(world:World, query, fetchComponents) {
		this.query = query;
		this.fetchComponents = fetchComponents;
		this.list = world.entities.observe(query).map(entities -> entities.map(e -> new Node(e, fetchComponents(e))));
	}

	public inline function iterator() {
		return list.value.iterator();
	}

	inline function get_length()
		return list.value.length;

	public static macro function generate(e);
}
