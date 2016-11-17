package ecs;

#if macro using tink.MacroApi; #end

interface Component {}

abstract ComponentType(String) {
	inline function new(v:String)
		this = v;
	
	// @:from
	// public static inline function ofClass(v:Class<Component>):ComponentType
	// 	return new ComponentType(Type.getClassName(v));
		
	// @:from
	// public static inline function ofInstance(v:Component):ComponentType
	// 	return ofClass(Type.getClass(v));
		
	@:from
	public static macro function of(e:haxe.macro.Expr):haxe.macro.Expr.ExprOf<ComponentType> {
		var type = haxe.macro.Context.typeof(e).reduce();
		trace(type);
		trace(type.getID());
		var expr = switch haxe.macro.Context.typeof(e).reduce() {
			case TInst(_.get() => {pack: ['ecs'], name: 'Component'}, []): macro Type.getClassName(Type.getClass($e));
			case TAnonymous(_.get() => a): trace(a); macro 'todo';
			case TInst(_.get() =>)
				macro 'todo';
		}
		return macro @:pos(e.pos) @:privateAccess new ecs.Component.ComponentType(${expr});
	}
		
	@:to
	public inline function toClass():Class<Component>
		return cast Type.resolveClass(this);
		
	@:to
	public inline function toString():String
		return this;
}

@:forward
abstract ComponentProvider(ComponentProviderObject) from ComponentProviderObject to ComponentProviderObject {
	@:from
	public static inline function ofComponent(v:Component):ComponentProvider {
		return new ComponentInstanceProvider(v);
	}
}

class ComponentInstanceProvider implements ComponentProviderObject {
	var component:Component;
	var id:String;
	
	public function new(component, ?id) {
		this.component = component;
		this.id = switch id {
			case null: ComponentType.of(component).toString();
			case id: id;
		}
	}
		
	public function get()
		return component;
		
	public function identifier():String
		return id;
}

interface ComponentProviderObject {
	function get():Component;
	function identifier():String;
}