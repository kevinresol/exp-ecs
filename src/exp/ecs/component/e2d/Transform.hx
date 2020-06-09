package exp.ecs.component.e2d;

import hxmath.math.Matrix3x2 as Matrix;

class Transform extends Component {

	public var a(get, set):Float;
	public var b(get, set):Float;
	public var c(get, set):Float;
	public var d(get, set):Float;
	public var tx(get, set):Float;
	public var ty(get, set):Float;
	
	@:isVar
	public var rotation(get, set):Float;
	
	public final global:Global;
	public var parent(default, set):Null<Transform>;
	
	final local:Matrix;
	@:noCompletion var dirty:Bool = true;

	public function new(a, b, c, d, tx, ty) {
		local = new Matrix(a, b, c, d, tx, ty);
		global = new Global();
	}
	
	inline function get_a() return local.a;
	inline function get_b() return local.b;
	inline function get_c() return local.c;
	inline function get_d() return local.d;
	inline function get_tx() return local.tx;
	inline function get_ty() return local.ty;
	inline function get_rotation() return rotation;

	
	inline function set_parent(v:Transform) return set(parent, v);
	inline function set_a(v:Float) return set(local.a, v);
	inline function set_b(v:Float) return set(local.b, v);
	inline function set_c(v:Float) return set(local.c, v);
	inline function set_d(v:Float) return set(local.d, v);
	inline function set_tx(v:Float) return set(local.tx, v);
	inline function set_ty(v:Float) return set(local.ty, v);
	inline function set_rotation(v:Float) {
		if(rotation != v) {
			dirty = true;
			local.setRotate(v);
		}
		return rotation = v;
	}
	
	static macro function set(field, value);
}

@:allow(exp.ecs)
@:forward(copyTo, clone)
abstract Global(Matrix) {
	public var a(get, never):Float;
	public var b(get, never):Float;
	public var c(get, never):Float;
	public var d(get, never):Float;
	public var tx(get, never):Float;
	public var ty(get, never):Float;
	
	public inline function new() 
		this = Matrix.zero;
	
	inline function get_a() return this.a;
	inline function get_b() return this.b;
	inline function get_c() return this.c;
	inline function get_d() return this.d;
	inline function get_tx() return this.tx;
	inline function get_ty() return this.ty;
	
	// internal use only
	inline function set_a(v:Float) return this.a = v;
	inline function set_b(v:Float) return this.b = v;
	inline function set_c(v:Float) return this.c = v;
	inline function set_d(v:Float) return this.d = v;
	inline function set_tx(v:Float) return this.tx = v;
	inline function set_ty(v:Float) return this.ty = v;
	
	inline function toMatrix():Matrix return this;
}