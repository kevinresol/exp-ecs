package exp.ecs;

import haxe.macro.Expr;

using tink.MacroApi;

class NodeList {
	public static macro function generate(world:Expr, query:Expr) {
		return macro exp.ecs.NodeList.make($world, ${parseQuery(query)}, e -> ${
			EObjectDecl([
				for (name => entry in getComponents(query))
					{
						field: name,
						expr: if (entry.hierarchy.length == 0) {
							macro e.get(${entry.component});
						} else if (entry.optional) {
							macro {
								var entity = e;
								for (v in ${getRuntimeHierarchy(entry.hierarchy)}) {
									entity = switch v {
										case Parent: entity.parent;
										case Linked(key): entity.linked[key];
									}
									if (entity == null)
										break;
								}
								entity == null ? null : entity.get(${entry.component});
							}
						} else {
							var root = macro e;
							for (v in entry.hierarchy)
								root = switch v {
									case Parent: macro $root.parent;
									case Linked(key): macro $root.linked[$key];
								}
							macro $root.get(${entry.component});
						}
					}
			]).at(query.pos)
		});
	}
	
	static function getRuntimeHierarchy(hierarchy:Array<Hierarchy>) {
		var arr = [for(v in hierarchy) switch v {
			case Parent: macro exp.ecs.NodeList.Hierarchy.Parent;
			case Linked(key): macro exp.ecs.NodeList.Hierarchy.Linked($key);
		}];
		return macro $a{arr}
	}

	static function getComponents(root:Expr) {
		final map = new Map();

		inline function lowerFirst(v:String)
			return v.charAt(0).toLowerCase() + v.substr(1);

		// TODO: currently it lists all components that appeared, but should be smarter to know which are optional and which are excluded
		(function traverse(e:Expr, hierarchy:Array<Hierarchy>, key:String = null, optional = false) {
			function add(key:String) {
				switch map[key] {
					case null:
						map[key] = {component: e, hierarchy: hierarchy, optional: optional}
					case entry:
						e.pos.error('Duplicate field "$key" in ${root.toString()}, use @:field(name) or construct a NodeList manually');
				}
			}

			switch e.expr {
				case ECall(macro Parent, [e]):
					traverse(e, hierarchy.concat([Parent]), key, optional);
				case ECall(macro Linked, [ekey, e]):
					traverse(e, hierarchy.concat([Linked(ekey)]), key, optional);
				case EParenthesis(e) | ECall(_, [e]):
					traverse(e, hierarchy, key, optional);
				case EUnop(OpNot, false, e):
					traverse(e, hierarchy, key, optional);
				case EUnop(OpNegBits, false, e):
					traverse(e, hierarchy, key, true);
				case EBinop(OpBoolAnd, e1, e2):
					traverse(e1, hierarchy, key, optional);
					traverse(e2, hierarchy, key, optional);
				case EBinop(OpBoolOr, e1, e2):
					traverse(e1, hierarchy, key, optional);
					traverse(e2, hierarchy, key, true);
				case EMeta({name: ':field', params: [{expr: EConst(CIdent(key))}]}, e):
					traverse(e, hierarchy, key, optional);
				case EField(_, v) | EConst(CIdent(v)):
					if (key == null)
						key = lowerFirst(v);
					add(key);
				case _:
					e.pos.error('Unsupported expression: ${e.toString()}');
			}
		})(root, []);

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
			case EParenthesis(e) | EMeta(_, e):
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
		};
	}

	static function parseComponent(e:Expr) {
		return switch e.expr {
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
			case ECall(macro Linked, [key, parseMod(_) => sub]):
				{mod: macro @:pos(e.pos) Linked($key, ${sub.mod}), component: sub.component}
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

private enum Hierarchy {
	Parent;
	Linked(key:Expr);
}

// Parent(Comp);
// parent.owns(Comp);

// Linked('k1', Comp);
// linked['k1'].owns(Comp);

// Parent(Linked('k1', Comp));
// parent.linked['k1'].owns(Comp);