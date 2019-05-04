package exp.ecs.node;

#if !macro 
@:genericBuild(exp.ecs.node.Node.build())
class Node<Rest> {}
#else

import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.BuildCache;

using tink.MacroApi;
using haxe.macro.TypeTools;
using StringTools;
using Lambda;

class Node {
	public static function build() {
		return switch Context.getLocalType() {
			case TInst(_, [type = _.reduce() => TAnonymous(_)]):
				buildAnon(type);
			case TInst(_, params):
				params.sort(function(t1, t2) return Reflect.compare(t1.getID(), t2.getID()));
				buildRest(params);
			default: throw 'assert';
		}
	}
	
	static function buildAnon(type) {
		return BuildCache.getType('exp.ecs.node.Node', type, function(ctx:BuildContext) {
			return switch ctx.type {
				case TAnonymous(_.get() => {fields: f}):
					var fields = [];
					for(field in f) {
						if(isComponent(field.type, field.pos)) {
							fields.push({
								name: field.name,
								type: field.type.reduce().toComplex(),
								optional: field.meta.has(':optional'),
							});
						}
					}
					buildClass(ctx.name, fields, ctx.pos);
				case _:
					throw 'unreachable';
			}
		});
	}
	
	static function buildRest(types) {	
		return BuildCache.getTypeN('exp.ecs.node.Node', types, function(ctx:BuildContextN) {
			var fields = [];
			for(type in ctx.types) {
				if(isComponent(type, ctx.pos)) {
					var cls = type.getClass();
					fields.push({
						name: cls.name.substr(0, 1).toLowerCase() + cls.name.substr(1), // auto named in the component's class name camel-cased
						type: type.toComplex(),
						optional: false,
					});
				}
			}
			
			return buildClass(ctx.name, fields, ctx.pos);
		});
	}
	
	static function isComponent(type, pos:Position) {
		return if(exp.ecs.util.Macro.isComponent(type)) {
			true;
		} else {
			pos.error('Expected a class that extends Component, but ${type.getID()} doesn\'t.');
			false;
		}
	}
	
	static function buildClass(name:String, fields:Array<NodeField>, pos) {
		var tp = 'exp.ecs.node.$name'.asTypePath();
		var nodeListTp = 'exp.ecs.node.TrackingNodeList'.asTypePath([TPType(TPath(tp)), TPType(macro:Event)]);
		var ctExprs = [for(field in fields) if(!field.optional) macro $p{field.type.toString().split('.')}];
		var description = [for(field in fields) (field.optional ? '?' : '') + field.type.toString().split('.').pop()].join(',');
		var ctorExprs = [];
		var onAddedExprs = [];
		var onRemovedExprs = [];
		var destroyExprs = [];
		
		var def = macro class $name extends exp.ecs.node.TrackingNode {
			static var componentTypes:Array<exp.ecs.component.ComponentType> = $a{ctExprs};
			
			public function new(entity) {
				super(entity, 'TrackingNode#' + $v{description});
				$b{ctorExprs}
			}
			
			public static function createNodeList<Event>(engine:exp.ecs.Engine<Event>) {
				return new $nodeListTp(
					engine,
					$p{['exp', 'ecs', 'node', name, 'new']},
					function(entity) return entity.hasAll(componentTypes),
					'TrackingNodeList#' + $v{description}
				);
			}
			
			override function destroy() {
				super.destroy();
				$b{destroyExprs}
			}
			
			override function onComponentAdded(__component:exp.ecs.component.Component) $b{onAddedExprs};
			override function onComponentRemoved(__component:exp.ecs.component.Component) $b{onRemovedExprs};
		}
		
		for(field in fields) {
			var name = field.name;
			var ct = field.type;
			var ctExpr = macro $p{ct.toString().split('.')}
			
			ctorExprs.push(macro this.$name = entity.get($p{ct.toString().split('.')}));
			onAddedExprs.push(macro if(__component.type == $ctExpr) this.$name = cast __component);
			onRemovedExprs.push(macro if(__component.type == $ctExpr) this.$name = null);
			destroyExprs.push(macro this.$name = null);
			
			def.fields.push({
				name: name,
				kind: FVar(ct),
				pos: pos,
				access: [APublic],
				meta: null,
			});
		}
		
		def.pack = ['exp', 'ecs', 'node'];
		return def;
	}
}

typedef NodeField = {
	name:String,
	type:ComplexType,
	optional:Bool,
}
#end
