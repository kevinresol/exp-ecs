package exp.ecs;

import tink.state.ObservableArray;
import tink.state.State;
import haxe.ds.ReadOnlyArray;
import tink.state.Observable;
import tink.state.ObservableMap;

class Object<T:Object<T>> {
	public final id:Int;

	final type:String;

	/**
	 * Inheritance
	 */
	public var base(get, set):Null<T>;

	final _base:State<Null<T>> = new State(null);

	public var derived(get, never):ObservableArrayView<T>;

	final _derived:ObservableArray<T> = new ObservableArray();

	/**
	 * Hierarchy
	 */
	public var parent(get, set):Null<T>;

	final _parent:State<Null<T>> = new State(null);

	public var children(get, never):ObservableArrayView<T>;

	final _children:ObservableArray<T> = new ObservableArray();

	/**
	 * Linkage
	 */
	public var linked(get, never):GranularMap<String, Entity>;

	final _linked:GranularMap<String, Entity> = new GranularMap([]);

	final components:GranularMap<Signature, Component> = new GranularMap([]);

	function new(id, type) {
		this.id = id;
		this.type = type;
	}

	public inline function link(key:String, entity:Entity) {
		_linked.set(key, entity);
	}

	public inline function unlink(key:String) {
		_linked.remove(key);
	}

	public function add(component:Component) {
		final signature = component.signature;
		if (owns(signature))
			throw '${toString()}: Cannot add components of the same signature twice, even it is the same instance';
		components.set(signature, component);
	}

	public function remove(signature:Signature) {
		if (owns(signature))
			components.remove(signature);
	}

	public macro function get(ethis, e);

	public inline function has(signature:Signature) {
		return owns(signature) || baseHas(signature);
	}

	public inline function shares(signature:Signature) {
		return !owns(signature) && baseHas(signature);
	}

	public inline function owns(signature:Signature) {
		return components.exists(signature);
	}

	public function fulfills(query:Query) {
		return switch query {
			case And(q1, q2): fulfills(q1) && fulfills(q2);
			case Or(q1, q2): fulfills(q1) || fulfills(q2);
			case Component(Optional, _, _): true;
			case Component(Not, Owned, sig): !owns(sig);
			case Component(Not, Shared, sig): !shares(sig);
			case Component(Not, Whatever, sig): !has(sig);
			case Component(Not, Parent(mod), sig):
				switch parent {
					case null: true;
					case parent: parent.fulfills(Component(Not, mod, sig));
				}
			case Component(Not, Linked(key, mod), sig):
				switch linked.get(key) {
					case null: true;
					case linked: linked.fulfills(Component(Not, mod, sig));
				}
			case Component(Must, Owned, sig): owns(sig);
			case Component(Must, Shared, sig): shares(sig);
			case Component(Must, Whatever, sig): has(sig);
			case Component(Must, Parent(mod), sig):
				switch parent {
					case null: false;
					case parent: parent.fulfills(Component(Must, mod, sig));
				}
			case Component(Must, Linked(key, mod), sig):
				switch linked.get(key) {
					case null: false;
					case linked: linked.fulfills(Component(Must, mod, sig));
				}
		}
	}

	function getComponent(signature:Signature):Null<Component> {
		return switch components.get(signature) {
			case null:
				switch base {
					case null: null;
					case base: base.getComponent(signature);
				}
			case v:
				cast v;
		}
	}

	inline function baseHas(signature:Signature) {
		return switch base {
			case null: false;
			case base: base.has(signature);
		}
	}

	inline function get_base() {
		return _base.value;
	}

	function set_base(v:T) {
		final current = _base.value;
		if (v != current) {
			if (current != null)
				(cast current.children : ObservableArray<T>).remove(cast this);
			if (v != null)
				(cast v.children : ObservableArray<T>).push(cast this);
			_base.set(v);
		}
		return v;
	}

	inline function get_parent() {
		return _parent.value;
	}

	function set_parent(v:T) {
		final current = _parent.value;
		if (v != current) {
			if (current != null)
				(cast current.children : ObservableArray<T>).remove(cast this);
			if (v != null)
				(cast v.children : ObservableArray<T>).push(cast this);
			_parent.set(v);
		}
		return v;
	}

	inline function get_derived():ObservableArrayView<T> {
		return _derived.view;
	}

	inline function get_children():ObservableArrayView<T> {
		return _children.view;
	}

	inline function get_linked():GranularMap<String, Entity> {
		return _linked;
	}

	public function toString():String {
		return switch get(exp.ecs.component.Name) {
			case null: '$type#$id';
			case {value: name}: '$type:$name#$id';
		}
	}
}
