package ecs;

import haxe.macro.Expr;
import haxe.macro.Context;
using tink.MacroApi;

class Macro {
	
	public static function buildNode() {
		var pos = Context.currentPos();
		switch Context.getLocalType() {
			case TInst(_, params):
				var fullnames = [];
				var names = []; 
				var complexTypes = [];
				for(param in params) switch param.reduce() {
					case TInst(_.get() => cls, _):
						fullnames.push(cls.pack.concat([cls.name]).join('_'));
						names.push(cls.name.substr(0, 1).toLowerCase() + cls.name.substr(1));
						complexTypes.push(param.toComplex());
					default: Context.error('Expected class', pos);
				}
				fullnames.sort(Reflect.compare);
				var name = 'Node_' + Context.signature(fullnames.join('_'));
				try return Context.getType('ecs.node.$name') catch(e:Dynamic) {}
				
				var tp = 'ecs.node.$name'.asTypePath();
				var arr = complexTypes.map(function(ct) return macro $p{ct.toString().split('.')});
				var ctorArgs = complexTypes.map(function(ct) return macro entity.get($p{ct.toString().split('.')}));
					
				var def = macro class $name implements ecs.Node.NodeBase {
					
					public static var componentTypes:Array<ecs.Component.ComponentType> = $a{arr};
					public static function createFor(entity:ecs.Entity)
						return entity.hasAll(componentTypes) ? haxe.ds.Option.Some(new $tp($a{ctorArgs})) : haxe.ds.Option.None;
					
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
				
			default: Context.error('Expected class', pos);
		}
		throw 'Error: check error message above';
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
		var nodect = type.toComplex();
		var nodename = nodect.toString().split('.');
		
		var sysname = 'NodeListSystem_' + Context.signature(cls);
		try return Context.getType('ecs.system.$sysname') catch(e:Dynamic) {}
			
		var def = macro class $sysname extends ecs.System.NodeListSystemBase<$nodect> {
			override function onAdded(engine:ecs.Engine) {
				nodes = new Map();
				for(e in engine.entities) addEntityIfMatch(e);
				
				listeners = [
					engine.entityAdded.handle(function(e) addEntityIfMatch(e)),
					engine.entityRemoved.handle(function(e) nodes.remove(e)),
				];
			}
			
			function addEntityIfMatch(entity:ecs.Entity) {
				switch $p{nodename}.createFor(entity) {
					case Some(node): nodes.set(entity, node);
					case None:
				}
			}
		}
		def.pack = ['ecs', 'system'];
		Context.defineType(def);
		
		return Context.getType('ecs.system.$sysname');
	}
}