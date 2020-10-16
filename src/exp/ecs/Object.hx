package exp.ecs;

import tink.state.Observable;
import tink.state.ObservableMap;

class Object<T:Object<T>> {
	public final id:Int;

	final type:String;

	/**
	 * Inheritance
	 */
	public var base:Null<T> = null;

	public final derived:Array<T> = [];

	/**
	 * Hierarchy
	 */
	public var parent:Null<T> = null;

	public final children:Array<T> = [];

	final components:ObservableMap<Signature, Component> = new ObservableMap([]);

	function new(id, type) {
		this.id = id;
		this.type = type;
	}

	public function add(component:Component) {
		final signature = component.signature;
		if (owns(signature))
			throw 'Cannot add components of the same signature twice, even it is the same instance';
		components.set(signature, component);
	}

	public function remove(signature:Signature) {
		if (owns(signature))
			components.remove(signature);
	}

	public function get<T:Component>(signature:Class<T>):Null<T> {
		return switch components.get((cast signature : Class<Component>)) {
			case null: if (base != null) base.get(signature) else null;
			case v: cast v;
		}
	}

	public function has(signature:Signature) {
		return owns(signature) || (base != null && base.has(signature));
	}

	public function shares(signature:Signature) {
		return !owns(signature) && base != null && base.has(signature);
	}

	public inline function owns(signature:Signature) {
		return components.exists(signature);
	}

	public function fulfills(query:Query) {
		return switch query {
			case And(q1, q2): fulfills(q1) && fulfills(q2);
			case Or(q1, q2): fulfills(q1) || fulfills(q2);
			case Not(mod, sig): !fulfills(Must(mod, sig));
			case Optional(_): true;
			case Must(Owned, sig): owns(sig);
			case Must(Shared, sig): shares(sig);
			case Must(Whatever, sig): has(sig);
			case Must(Parent(mod), sig): parent != null && parent.fulfills(Must(mod, sig));
		}
	}

	final cache = new Map();

	public function observe(query:Query):Observable<Bool> {
		// return Observable.auto(fulfills.bind(query));
		final key = Std.string(query); @:nullSafety(Off) return switch cache[key] {
			case null: cache[key] = Observable.auto(fulfills.bind(query));
			case cached: cached;
		}
	}

	public function toString():String {
		return switch get(exp.ecs.component.Name) {
			case null: '$type#$id';
			case {value: name}: '$type:$name';
		}
	}
}
