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
		trace(toString() + ': fulfills $query');
		return switch query {
			case And(q1, q2): fulfills(q1) && fulfills(q2);
			case Or(q1, q2): fulfills(q1) || fulfills(q2);
			case Component(Optional, _, _): true;
			case Component(Not, Owned, sig): !owns(sig);
			case Component(Not, Shared, sig): !shares(sig);
			case Component(Not, Whatever, sig): !has(sig);
			case Component(Not, Parent(mod), sig): parent == null || parent.fulfills(Component(Not, mod, sig));
			case Component(Must, Owned, sig): owns(sig);
			case Component(Must, Shared, sig): shares(sig);
			case Component(Must, Whatever, sig): has(sig);
			case Component(Must, Parent(mod), sig): parent != null && parent.fulfills(Component(Must, mod, sig));
		}
	}

	public function toString():String {
		return switch get(exp.ecs.component.Name) {
			case null: '$type#$id';
			case {value: name}: '$type:$name';
		}
	}
}
