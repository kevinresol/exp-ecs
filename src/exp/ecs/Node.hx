package exp.ecs;

class Node<T> {
	public final entity:Entity;
	public final data:T;

	public function new(entity, data) {
		this.entity = entity;
		this.data = data;
	}
}
