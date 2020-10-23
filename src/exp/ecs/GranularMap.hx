package exp.ecs;

import tink.state.*;
import tink.state.internal.Invalidatable;

// brutal hack for https://github.com/haxetink/tink_state/issues/49
typedef GranularMap<K, V> = ObservableMap<K, V>;

// @:nullSafety(Off)
// class GranularMap<K, V> extends Invalidator {
// 	final dataMap:Map<K, State<V>>;
// 	final existenceMap:Map<K, State<Bool>>;
// 	var valid:Bool = true;
// 	public function new(d, e) {
// 		super();
// 		this.dataMap = d;
// 		this.existenceMap = e;
// 	}
// 	public function exists(key:K):Bool {
// 		return (switch existenceMap.get(key) {
// 			case null: existenceMap[key] = new State(false);
// 			case v: v;
// 		}).value;
// 	}
// 	public function get(key:K) {
// 		return (switch dataMap.get(key) {
// 			case null: dataMap[key] = new State(null);
// 			case v: v;
// 		}).value;
// 	}
// 	public function set(key:K, value:V) {
// 		switch existenceMap.get(key) {
// 			case null:
// 				existenceMap[key] = new State(true);
// 			case v:
// 				v.set(true);
// 		}
// 		switch dataMap.get(key) {
// 			case null:
// 				dataMap[key] = new State(value);
// 			case v:
// 				v.set(value);
// 		}
// 	}
// 	public function remove(key:K) {
// 		switch existenceMap.get(key) {
// 			case null:
// 			case v:
// 				v.set(false);
// 		}
// 		switch dataMap.get(key) {
// 			case null:
// 			case v:
// 				v.set(null);
// 		}
// 	}
// 	public inline function keys() {
// 		return new GranularMapKeyIterator(this);
// 	}
// 	public inline function iterator() {
// 		return new GranularMapIterator(this);
// 	}
// 	public inline function keyValueIterator() {
// 		return new GranularMapKeyValueIterator(this);
// 	}
// }
// @:nullSafety(Off)
// private class GranularMapKeyIterator<K, V> {
// 	var map:GranularMap<K, V>;
// 	var keys:Iterator<K>;
// 	var current:K;
// 	public inline function new(map) {
// 		this.map = map;
// 		this.keys = @:privateAccess map.existenceMap.keys();
// 	}
// 	/**
// 		See `Iterator.hasNext`
// 	**/
// 	public inline function hasNext():Bool {
// 		var result = false;
// 		while (keys.hasNext()) {
// 			if (@:privateAccess map.existenceMap[current = keys.next()]) {
// 				result = true;
// 				break;
// 			}
// 		}
// 		return result;
// 	}
// 	/**
// 		See `Iterator.next`
// 	**/
// 	public inline function next():K {
// 		return current;
// 	}
// }
// @:nullSafety(Off)
// private class GranularMapKeyValueIterator<K, V> {
// 	var map:GranularMap<K, V>;
// 	var keys:Iterator<K>;
// 	public inline function new(map) {
// 		this.map = map;
// 		this.keys = map.keys();
// 	}
// 	/**
// 		See `Iterator.hasNext`
// 	**/
// 	public inline function hasNext():Bool {
// 		return keys.hasNext();
// 	}
// 	/**
// 		See `Iterator.next`
// 	**/
// 	public inline function next():{key:K, value:V} {
// 		var key = keys.next();
// 		return {value: @:nullSafety(Off) (@:privateAccess map.dataMap.get(key).value : V), key: key};
// 	}
// }
// @:nullSafety(Off)
// private class GranularMapIterator<K, V> {
// 	var map:GranularMap<K, V>;
// 	var keys:Iterator<K>;
// 	public inline function new(map) {
// 		this.map = map;
// 		this.keys = map.keys();
// 	}
// 	/**
// 		See `Iterator.hasNext`
// 	**/
// 	public inline function hasNext():Bool {
// 		return keys.hasNext();
// 	}
// 	/**
// 		See `Iterator.next`
// 	**/
// 	public inline function next():V {
// 		var key = keys.next();
// 		return @:nullSafety(Off) (@:privateAccess map.dataMap.get(key).value : V);
// 	}
// }
