package ecs.util;

import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.BuildCache;

using tink.MacroApi;
using StringTools;

class Macro {
	
	public static function buildNode() {
		var types = switch Context.getLocalType() {
			case TInst(_, params):
				params.sort(function(t1, t2) return Reflect.compare(t1.getID(), t2.getID()));
				params;
			default: throw 'assert';
		}
		
		return BuildCache.getTypeN('ecs.node.Node', types, function(ctx:BuildContextN) {
			var pos = ctx.pos;
			var name = ctx.name;
			
			var fullnames = [];
			var names = []; 
			var complexTypes = [];
			for(type in ctx.types) {
				switch type.reduce() {
					case TInst(_.get() => cls, _) if(isComponent(type)):
						names.push(cls.name.substr(0, 1).toLowerCase() + cls.name.substr(1));
						complexTypes.push(type.toComplex());
					default: pos.makeFailure('Expected a class that extends Component, but got ${type.getID()}').sure();
				}
			}
			
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
							nodes.add(new $tp($a{ctorArgs}));
							
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
			for(i in 0...names.length) {
				var name = names[i];
				var ct = complexTypes[i];
				
				// Prepare the constructor args for the node class
				ctorArgs.push({
					name: name,
					type: ct,
					opt: false,
					meta: null,
					value: null,
				});
				
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
			var exprs = names.map(function(name) return macro this.$name = $i{name});
			exprs.push(macro this.entity = entity);
			def.fields.push({
				name: 'new',
				kind: FFun({
					args: ctorArgs,
					expr: macro $b{exprs},
					ret: null,
				}),
				pos: pos,
				access: [APublic],
				meta: null
			});
			def.pack = ['ecs', 'node'];
			
			return def;
		});
	}
	
	public static function buildNodeListSystem():Array<Field> {
		var builder = new ClassBuilder();
		var addedExprs = [];
		var removedExprs = [];
		for(field in builder) {
			switch field.extractMeta(':nodes') {
				case Success(_):
					var name = field.name;
					switch field.kind {
						case FVar(ct, e):
							var ct = ct.toType().sure().toComplex();
							field.kind = FVar(macro:ecs.node.NodeList<$ct>, e);
							addedExprs.push(macro $i{name} = engine.getNodeList($p{ct.toString().split('.')}));
							removedExprs.push(macro $i{name} = null);
						case _: field.pos.error('Unsupported');
					}
				case Failure(_):
			}
		}
		
		builder.addMembers(macro class {
			override function setNodeLists(engine:ecs.Engine) $b{addedExprs}
			override function unsetNodeLists() $b{removedExprs}
		});
		return builder.export();
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