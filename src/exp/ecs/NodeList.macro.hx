package exp.ecs;

import haxe.macro.Expr;

using tink.MacroApi;

class NodeList {
	public static macro function generate(world:Expr, query:Expr) {
		return macro new exp.ecs.NodeList($world, ${parseQuery(query)}, e -> ${
			EObjectDecl([
				for (name => entry in getComponents(query))
					{field: name, expr: macro e.get(${entry.expr})}
			]).at(query.pos)
		});
	}

	static function getComponents(e:Expr) {
		final map = new Map();

		inline function lowerFirst(v:String)
			return v.charAt(0).toLowerCase() + v.substr(1);

		// TODO: currently it lists all components that appeared, but should be smarter to know which are optional and which are excluded
		(function traverse(e:Expr, optional = false) {
			function add(key:String) {
				switch map[key] {
					case null:
						map[key] = {expr: e, optional: optional}
					case entry:
						entry.optional = entry.optional || optional;
				}
			}

			switch e.expr {
				case EParenthesis(e) | ECall(_, [e]):
					traverse(e);
				case EUnop(OpNot, false, e):
					traverse(e);
				case EUnop(OpNegBits, false, e):
					traverse(e, true);
				case EBinop(OpBoolAnd, e1, e2) | EBinop(OpBoolOr, e1, e2):
					traverse(e1);
					traverse(e2);
				case EMeta({name: ':field', params: [{expr: EConst(CIdent(key))}]}, {expr: EField(_, _) | EConst(CIdent(_))}):
					add(lowerFirst(key));
				case EField(_, v) | EConst(CIdent(v)):
					add(lowerFirst(v));
				case _:
					e.pos.error('Unsupported expression: ${e.toString()}');
			}
		})(e);

		/*
			// get T from a Class<T> expr
			for (expr in map) {
				var type = haxe.macro.Context.typeof(macro {
					function get<T>(c:Class<T>):T
						throw 0;
					get($expr);
				});
				trace(type);
			}
		 */

		return map;
	}

	static function parseQuery(e:Expr) {
		return (switch e.expr {
			case EParenthesis(e):
				macro @:pos(e.pos) ${parseQuery(e)};
			case EBinop(OpBoolAnd, e1, e2):
				macro @:pos(e.pos) And(${parseQuery(e1)}, ${parseQuery(e2)});
			case EBinop(OpBoolOr, e1, e2):
				macro @:pos(e.pos) Or(${parseQuery(e1)}, ${parseQuery(e2)});
			case EUnop(OpNot, false, parseMod(_) => sub):
				macro @:pos(e.pos) Component(Not, ${sub.mod}, ${sub.component});
			case EUnop(OpNegBits, false, parseMod(_) => sub):
				macro @:pos(e.pos) Component(Optional, ${sub.mod}, ${sub.component});
			case _:
				final sub = parseMod(e);
				macro @:pos(e.pos) Component(Must, ${sub.mod}, ${sub.component});
		}).log();
	}

	static function parseComponent(e:Expr) {
		return switch e.expr {
			case EMeta({name: ':field', params: [_]}, sub):
				parseComponent(sub);
			case EField(_) | EConst(CIdent(_)):
				macro @:pos(e.pos) $e;
			case _:
				e.pos.error('Unsupported component expression: ${e.toString()}');
		}
	}

	static function parseMod(e:Expr):{mod:Expr, component:Expr} {
		return switch e.expr {
			case ECall(macro Parent, [parseMod(_) => sub]):
				{mod: macro @:pos(e.pos) Parent(${sub.mod}), component: sub.component}
			case ECall(macro Shared, [sub]):
				{mod: macro @:pos(e.pos) Shared, component: parseComponent(sub)}
			case ECall(macro Owned, [sub]):
				{mod: macro @:pos(e.pos) Owned, component: parseComponent(sub)}
			case ECall(macro Whatever, [sub]):
				{mod: macro @:pos(e.pos) Whatever, component: parseComponent(sub)}
			case ECall(call, [sub]):
				e.pos.error('Unsupported modifier ${call.toString()}');
			case _:
				{mod: macro @:pos(e.pos) Owned, component: parseComponent(e)}
		}
	}
}
