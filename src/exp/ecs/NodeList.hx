package exp.ecs;


class NodeList<T> {
	final query:Query;
	final fetchComponents:Entity->T;
	
	public function new(query, fetchComponents) {
		this.query = query;
		this.fetchComponents = fetchComponents;
	}

	public static macro function generate(e);
}