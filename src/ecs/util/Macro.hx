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
			var ctExprs = complexTypes.map(function(ct) return macro $p{ct.toString().split('.')});
			var nodeListTp = 'ecs.node.TrackingNodeList'.asTypePath([TPType(TPath(tp))]);
			
			var def = macro class $name implements ecs.node.NodeBase {
				public var entity(default, null):ecs.entity.Entity;
				
				public static function createNodeList(engine:ecs.Engine) {
					return new $nodeListTp(engine, $p{['ecs', 'node', name, 'new']}, $a{ctExprs});
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
							field.kind = FVar(macro:ecs.node.TrackingNodeList<$ct>, e);
							addedExprs.push(macro $i{name} = cast engine.getNodeList($p{ct.toString().split('.')}));
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
	
	static function toTypeParams(types:Array<haxe.macro.Type>):Array<TypeParam> {
		return [for (p in types) TPType(p.toComplex())];
	}
}