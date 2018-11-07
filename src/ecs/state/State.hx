package ecs.state;

class State<Item> {
	public var items(default, null):Array<Item>;
	
	public function new(?items) {
		this.items = items == null ? [] : items;
	}
}