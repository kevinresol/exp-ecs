package exp.ecs.state;

using tink.CoreApi;

class FiniteStateMachine<Target, Item> {
	var target:Target;
	var states:Map<String, State<Item>>;
	var nexts:Map<String, Array<String>>;
	var current:String;
	
	public function new(target) {
		this.target = target;
		states = new Map();
		nexts = new Map();
	}
	
	public function add(name:String, state:State<Item>, next:Array<String>) {
		states.set(name, state);
		nexts.set(name, next);
	}
	
	public function transit(to:String):Outcome<Noise, Error> {
		return
			if(current == to)
				Success(Noise);
			else switch states.get(to) {
				case null:
					Failure(new Error('State "$to" doesn\'t exist'));
					
				case state:
					if(current == null || canTransit(current, to)) {
						switch states.get(current) {
							case null:
							case state: removeFromTarget(state.items);
						}
						addToTarget(state.items);
						current = to;
						Success(Noise);
					} else {
						Failure(new Error('Unable to transit from "$current" to "$to"'));
					}
			}
	}
	
	function removeFromTarget(items:Array<Item>) {}
	function addToTarget(items:Array<Item>) {}
	function canTransit(from:String, to:String) {
		return switch nexts.get(from) {
			case null: false;
			case v: v.indexOf(to) != -1;
		}
	}
}
