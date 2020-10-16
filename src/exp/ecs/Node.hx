package exp.ecs;

class Node<T> {
	public final entity:Entity;
	public final components:T;

	public function new(entity, components) {
		this.entity = entity;
		this.components = components;
	}
}
