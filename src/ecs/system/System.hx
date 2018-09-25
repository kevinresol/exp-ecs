package ecs.system;


#if !macro
import ecs.*;

@:autoBuild(ecs.system.System.build())
class System implements SystemBase {
	var engine:Engine;
	
	public function new() {}
	
	public function update(dt:Float) {}
	
	public function onAdded(engine:Engine) {
		this.engine = engine;
		setNodeLists(engine);
	}
	
	public function onRemoved(engine:Engine) {
		this.engine = null;
		unsetNodeLists();
	}
	
	function setNodeLists(engine:Engine) {
		throw 'abstract';
	}
	
	function unsetNodeLists() {
		throw 'abstract';
	}
}
#else

import haxe.macro.Expr;
import haxe.macro.Context;
import tink.macro.BuildCache;

using tink.MacroApi;
using StringTools;

class System {
	public static function build():Array<Field> {
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
							var parts = ct.toString().split('.');
							addedExprs.push(macro $i{name} = engine.getNodeList($p{parts}, $p{parts.concat(['createNodeList'])}));
							removedExprs.push(macro $i{name} = null);
						case _:
							field.pos.error('Unsupported');
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
}
#end
