package ecs;

import haxe.macro.Expr;
import haxe.macro.Context;
using tink.MacroApi;

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
		for(param in params) switch param.reduce() {
			case TInst(_.get() => cls, p):
				fullnames.push(cls.pack.concat([cls.name]).join('_') + (p.length == 0 ? '' : '<' + [for(p in p) p.getID()].join(',') + '>'));
				names.push(cls.name.substr(0, 1).toLowerCase() + cls.name.substr(1));
				complexTypes.push(param.toComplex());
			default: pos.makeFailure('Expected class').sure();
		}
		fullnames.sort(Reflect.compare);
		
		var name = 'Node_' + Context.signature(fullnames.join('_'));
		try return Context.getType('ecs.node.$name') catch(e:Dynamic) {}
		
		var tp = 'ecs.node.$name'.asTypePath();
		var arr = complexTypes.map(function(ct) return macro @:pos(pos) $p{ct.toString().split('.')});
		var ctorArgs = complexTypes.map(function(ct) return macro @:pos(pos) entity.get($p{ct.toString().split('.')}));
			
		var def = macro class $name implements ecs.Node.NodeBase {
			
			public static var componentTypes:Array<ecs.Component.ComponentType> = $a{arr};
			public static function createNodeList(engine:ecs.Engine) {
				var nodes = new ecs.Node.NodeList();
				var listeners = new Map();
				
				inline function addEntityIfMatch(entity:ecs.Entity) 
					if(entity.hasAll(componentTypes))
						nodes.add(entity, new $tp($a{ctorArgs}));
				
				inline function track(entity:ecs.Entity) {
					if(listeners.exists(entity)) return; // already tracking
					listeners.set(entity, [
						entity.componentAdded.handle(function() addEntityIfMatch(entity)),
						entity.componentRemoved.handle(function() addEntityIfMatch(entity)),
					]);
				}
				
				inline function untrack(entity:ecs.Entity) {
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
		var ctorArgs = []; 
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
		def.fields.push({
			name: 'new',
			kind: FFun({
				args: ctorArgs,
				expr: macro @:pos(pos) $b{names.map(function(name) return macro @:pos(pos) this.$name = $i{name})},
				ret: null,
			}),
			pos: pos,
			access: [APublic],
			meta: null
		});
		def.pack = ['ecs', 'node'];
		def.pos = pos;
		trace(new haxe.macro.Printer().printTypeDefinition(def));
		Context.defineType(def);
		return Context.getType('ecs.node.$name');
		
		
	}
	
	public static function buildNodeListSystem() {
		var type = switch Context.getLocalType() {
			case TInst(_, [type]): type.reduce();
			default: throw 'assert';
		}
		
		var cls = switch type {
			case TInst(_.get() => cls, _): cls;
			default: throw 'assert';
		}
		
		var sysname = 'NodeListSystem_' + Context.signature(cls);
		try return Context.getType('ecs.system.$sysname') catch(e:Dynamic) {}
		
		var nodect = type.toComplex();
		var nodename = nodect.toString().split('.');
			
		var def = macro class $sysname extends ecs.System.NodeListSystemBase<$nodect> {
			override function onAdded(engine:ecs.Engine) {
				nodes = engine.getNodeList($p{nodename});
			}
		}
		def.pack = ['ecs', 'system'];
		Context.defineType(def);
		
		return Context.getType('ecs.system.$sysname');
	}
	
	static var re = ~/Class<([^>]*)>/;
	public static function getNodeList(ethis:Expr, e:Expr) {
		var type = Context.typeof(e);
		if(!Context.unify(type, (macro:Class<ecs.Node.NodeBase>).toType().sure()))
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
}