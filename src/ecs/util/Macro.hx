package ecs.util;

import haxe.macro.Expr;
import haxe.macro.Context;
using tink.MacroApi;
using StringTools;

class Macro {
	
	public static function buildNode() {
		var pos = Context.currentPos();
		var params = switch Context.getLocalType() {
			case TInst(_, params): params;
			default: throw 'assert';
		}
		
		var fullnames = [];
		var names = []; 
		var complexTypes = [];
		for(param in params) {
			var type = param.reduce();
			switch type {
				case TInst(_.get() => cls, _) if(isComponent(type)):
					fullnames.push(cls.pack.concat([cls.name]).join('_'));
					names.push(cls.name.substr(0, 1).toLowerCase() + cls.name.substr(1));
					complexTypes.push(param.toComplex());
				default: pos.makeFailure('Expected a class that extends Component, but got ${type.getID()}').sure();
			}
		}
		fullnames.sort(Reflect.compare);
		var name = 'Node_' + Context.signature(fullnames.join('_'));
		try return Context.getType('ecs.node.$name') catch(e:Dynamic) {}
		
		var tp = 'ecs.node.$name'.asTypePath();
		var arr = complexTypes.map(function(ct) return macro $p{ct.toString().split('.')});
		var ctorArgs = [macro entity];
		for(ct in complexTypes) ctorArgs.push(macro entity.get($p{ct.toString().split('.')}));
			
		var def = macro class $name implements ecs.node.NodeBase {
			public var entity(default, null):ecs.entity.Entity;
			
			public static var componentTypes:Array<ecs.component.ComponentType> = $a{arr};
			public static function createNodeList(engine:ecs.Engine) {
				var nodes = new ecs.node.NodeList();
				var listeners = new Map();
				
				inline function addEntityIfMatch(entity:ecs.entity.Entity) 
					if(entity.hasAll(componentTypes))
						nodes.add(new $tp(entity));
						
				inline function removeEntityIfNoLongerMatch(entity:ecs.entity.Entity) 
					if(!entity.hasAll(componentTypes))
						nodes.removeEntity(entity);
				
				inline function track(entity:ecs.entity.Entity) {
					if(listeners.exists(entity)) return; // already tracking
					listeners.set(entity, [
						entity.componentAdded.handle(function() addEntityIfMatch(entity)),
						entity.componentRemoved.handle(function() removeEntityIfNoLongerMatch(entity)),
					]);
				}
				
				inline function untrack(entity:ecs.entity.Entity) {
					if(!listeners.exists(entity)) return; // not tracking
					var l = listeners.get(entity);
					while(l.length > 0) l.pop().dissolve();
					listeners.remove(entity);
				}
				
				for(entity in engine.entities) {
					addEntityIfMatch(entity);
					track(entity);
				}
					
				// TODO: if we destroy a node list, we need to dissolve the handlers
				engine.entityAdded.handle(function(e) {
					addEntityIfMatch(e);
					track(e);
				});
				engine.entityRemoved.handle(function(e) {
					nodes.removeEntity(e);
					untrack(e);
				});
				
				return nodes;
			}
			
		}
		
		var ctorArgs = [{
			name: 'entity',
			type: macro:ecs.entity.Entity,
			opt: false,
			meta: null,
			value: null,
		}]; 
		var ctorExprs = [macro this.entity = entity];
		for(i in 0...names.length) {
			var name = names[i];
			var ct = complexTypes[i];
			
			ctorExprs.push(macro this.$name = entity.get($p{ct.toString().split('.')}));
			
			// Create instance field for each component, named in the component's class name camel-cased
			def.fields.push({
				name: name,
				kind: FVar(ct),
				pos: pos,
				access: [APublic],
				meta: null,
			});
		}
		
		// constructor
		def.fields.push({
			name: 'new',
			kind: FFun({
				args: ctorArgs,
				expr: macro $b{ctorExprs},
				ret: null,
			}),
			pos: pos,
			access: [APublic],
			meta: null
		});
		def.pack = ['ecs', 'node'];
		
		Context.defineType(def);
		return Context.getType('ecs.node.$name');
		
		
	}
	
	public static function buildNodeListSystem() {
		
		var pos = Context.currentPos();
		var param = switch Context.getLocalType() {
			case TInst(_, [TAnonymous(_.get() => a)]): a;
			default: pos.makeFailure('Expected a single anonymous structure as the type parameter for NodeListSystem').sure();
		}
		
		var fullnames = [];
		var names = []; 
		var complexTypes = [];
		var addedExprs = [];
		var removedExprs = [];
		
		for(field in param.fields) {
			var name = field.name;
			var ct = field.type.toComplex();
			names.push(name);
			complexTypes.push(ct);
			addedExprs.push(macro $i{name} = engine.getNodeList($p{ct.toString().split('.')}));
			removedExprs.push(macro $i{name} = null);
		}
		
		var sysname = 'NodeListSystem_' + Context.signature(param);
		try return Context.getType('ecs.system.$sysname') catch(e:Dynamic) {}
		
		var def = macro class $sysname extends ecs.system.System {
			override function onAdded(engine:ecs.Engine) {
				super.onAdded(engine);
				$b{addedExprs}
			}
			override function onRemoved(engine:ecs.Engine) {
				super.onRemoved(engine);
				$b{removedExprs}
			}
		}
		
		for(i in 0...names.length)
			def.fields.push({
				name: names[i],
				kind: {
					var ct = complexTypes[i];
					FVar(macro:ecs.node.NodeList<$ct>);
				},
				pos: pos, 
			});
		def.pack = ['ecs', 'system'];
		Context.defineType(def);
		// trace(new haxe.macro.Printer().printTypeDefinition(def));
		
		return Context.getType('ecs.system.$sysname');
	}
	
	static var re = ~/Class<([^>]*)>/;
	public static function getNodeList(ethis:Expr, e:Expr) {
		var type = Context.typeof(e);
		if(!Context.unify(type, (macro:Class<ecs.node.NodeBase>).toType().sure()))
			e.pos.makeFailure('Expected Class<NodeBase>').sure();
			
		switch type {
			case TType(_.get() => def, []) if(re.match(def.name)):
				var name = re.matched(1);
				var cls = macro $p{name.split('.')};
				return macro @:privateAccess $ethis._getNodeList($cls, $cls.createNodeList);
			default:
		}
		e.pos.makeFailure('Expected Class<NodeBase>').sure();
		return macro null;
	}
	
	static function isComponent(type:haxe.macro.Type) {
		switch type.reduce() {
			case TInst(_.get() => cls, _):
				if(cls.superClass == null) return false;
				return switch cls.superClass.t.get() {
					case {name: 'Component', pack: ['ecs', 'component']}: true;
					default: false;
				}
			default: return false;
		}
	}
}