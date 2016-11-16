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
			case TInst(_.get() => cls, _):
				fullnames.push(cls.pack.concat([cls.name]).join('_'));
				names.push(cls.name.substr(0, 1).toLowerCase() + cls.name.substr(1));
				complexTypes.push(param.toComplex());
			default: pos.makeFailure('Expected class').sure();
		}
		fullnames.sort(Reflect.compare);
		var name = 'Node_' + Context.signature(fullnames.join('_'));
		try return Context.getType('ecs.node.$name') catch(e:Dynamic) {}
		
		var tp = 'ecs.node.$name'.asTypePath();
		var arr = complexTypes.map(function(ct) return macro $p{ct.toString().split('.')});
		var ctorArgs = complexTypes.map(function(ct) return macro entity.get($p{ct.toString().split('.')}));
			
		var def = macro class $name implements ecs.Node.NodeBase {
			
			public static var componentTypes:Array<ecs.Component.ComponentType> = $a{arr};
			public static function createNodeList(engine:ecs.Engine) {
				var result = new ecs.Node.NodeList();
				
				inline function addEntityIfMatch(entity:ecs.Entity) 
					if(entity.hasAll(componentTypes))
						result.add(entity, new $tp($a{ctorArgs}));
				
				for(entity in engine.entities) addEntityIfMatch(entity);
					
				// TODO: if we destroy a node list, we need to dissolve the handlers
				engine.entityAdded.handle(function(e) addEntityIfMatch(e));
				engine.entityRemoved.handle(function(e) result.removeEntity(e));
				
				return result;
			}
			
		}
		
		// Create instance field for each component, named in the component's class name camel-cased
		var ctorArgs = []; 
		for(i in 0...names.length) {
			var name = names[i];
			var ct = complexTypes[i];
			ctorArgs.push({
				name: name,
				type: ct,
				opt: false,
				meta: null,
				value: null,
			});
			def.fields.push({
				name: name,
				kind: FVar(ct),
				pos: pos,
				access: [APublic],
				meta: null,
			});
		}
		
		// constructor
		var args = complexTypes.map(function(ct) return Context.parse(ct.toString(), pos));
		def.fields.push({
			name: 'new',
			kind: FFun({
				args: ctorArgs,
				expr: macro $b{names.map(function(name) return macro this.$name = $i{name})},
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