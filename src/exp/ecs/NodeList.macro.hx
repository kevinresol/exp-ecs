package exp.ecs;

import haxe.macro.Expr;

using tink.MacroApi;

class NodeList {
	public static macro function generate(e:Expr) {
		return macro new exp.ecs.NodeList(${parseQuery(e)}, e -> ${
			EObjectDecl([
				for (name => entry in getComponents(e))
					{field: name, expr: macro e.get(${entry.expr})}
			]).at(e.pos)
		});
	}

	static function getComponents(e:Expr) {
		final map = new Map();

		inline function lowerFirst(v:String)
			return v.charAt(0).toLowerCase() + v.substr(1);

		// TODO: currently it lists all components that appeared, but should be smarter to know which are optional and which are excluded
		(function traverse(e:Expr, optional = false) {
			switch e.expr {
				case EParenthesis(e):
					traverse(e);
				case EUnop(OpNegBits, false, e):
					traverse(e, true);
				case EBinop(OpBoolAnd, e1, e2) | EBinop(OpBoolOr, e1, e2):
					traverse(e1);
					traverse(e2);
				case EField(_, v) | EConst(CIdent(v)):
					final key = lowerFirst(v);
					switch map[key] {
						case null: map[key] = {expr: e, optional: optional}
						case entry: entry.optional = entry.optional || optional;
					}
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
		return switch e.expr {
			case EParenthesis(e):
				macro @:pos(e.pos) ${parseQuery(e)};
			case EBinop(OpBoolAnd, e1, e2):
				macro @:pos(e.pos) And(${parseQuery(e1)}, ${parseQuery(e2)});
			case EBinop(OpBoolOr, e1, e2):
				macro @:pos(e.pos) Or(${parseQuery(e1)}, ${parseQuery(e2)});
			case EUnop(OpNot, false, ident = {expr: EField(_) | EConst(CIdent(_))}):
				macro @:pos(e.pos) Not(Owned, $ident);
			case EUnop(OpNegBits, false, ident = {expr: EField(_) | EConst(CIdent(_))}):
				macro @:pos(e.pos) Optional(Owned, $ident);
			case EField(_) | EConst(CIdent(_)):
				macro @:pos(e.pos) Must(Owned, $e);
			case _:
				e.pos.error('Unsupported expression: ${e.toString()}');
		}
	}
}
