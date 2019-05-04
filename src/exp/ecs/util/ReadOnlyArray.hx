package exp.ecs.util;

@:forward(concat, copy, filter, indexOf, join, lastIndexOf, map, slice, toString)
abstract ReadOnlyArray<T>(Array<T>) from Array<T> {
  public var length(get,never):Int;
  inline function get_length() return this.length;
  @:arrayAccess inline function get(i:Int) return this[i];
  public inline function iterator() return new ConstArrayIterator(this);
} 