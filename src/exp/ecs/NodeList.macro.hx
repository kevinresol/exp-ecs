package exp.ecs;

import haxe.macro.Expr;
import haxe.macro.Context;

using tink.MacroApi;

abstract NodeList(Dynamic) {
	public static macro function spec(query:Expr) {
		return macro new exp.ecs.NodeList.NodeListSpec(${parseQuery(query)}, e -> ${
			EObjectDecl([
				for (name => entry in getComponents(query))
					{
						field: name,
						expr: {
							function fetch(e)
								return switch entry.fetch {
									case Component(expr):
										macro $e.get(${expr});
									case Entity:
										macro $e;
								}
							if (entry.hierarchy.length == 0) {
								fetch(macro e); // TODO: should probably disallow fetching entity here, as it is already accessible as `node.entity`
							} else if (entry.optional) {
								macro {
									var entity = e;
									for (v in ${getRuntimeHierarchy(entry.hierarchy)}) {
										entity = switch v {
											case Parent: entity.parent;
											case Linked(key): entity.linked.get(key);
										}
										if (entity == null)
											break;
									}
									entity == null ? null : ${fetch(macro entity)};
								}
							} else {
								var root = macro e;
								for (v in entry.hierarchy)
									root = switch v {
										case Parent: macro $root.parent;
										case Linked(key): macro $root.linked.get($key);
									}
								fetch(root);
							}
						}
					}
			]).at(query.pos)
		});
	}

	public static function generate(world:Expr, query:Expr) {
		final pos = Context.currentPos();
		return macro @:pos(pos) exp.ecs.NodeList.make($world, exp.ecs.NodeList.spec($query));
	}

	static function getRuntimeHierarchy(hierarchy:Array<Hierarchy>) {
		final arr = [
			for (v in hierarchy)
				switch v {
					case Parent:
						macro exp.ecs.NodeList.Hierarchy.Parent;
					case Linked(key):
						macro exp.ecs.NodeList.Hierarchy.Linked($key);
				}
		];
		return macro $a{arr}
	}

	static function getComponents(root:Expr) {
		final map = new Map();

		inline function lowerFirst(v:String)
			return v.charAt(0).toLowerCase() + v.substr(1);

		// TODO: currently it lists all components that appeared, but should be smarter to know which are optional and which are excluded
		(function traverse(e:Expr, hierarchy:Array<Hierarchy>, componentKey:String = null, entityKey:String = null, optional = false) {
			function add(cKey:String, eKey:String) {
				switch map[cKey] {
					case null:
						map[cKey] = {fetch: Fetch.Component(e), hierarchy: hierarchy, optional: optional}
					case entry:
						e.pos.error('Duplicate field "$cKey" in ${root.toString()}, use @:component(name) or construct a NodeList manually');
				}
				if (eKey != null)
					switch map[eKey] {
						case null:
							map[eKey] = {fetch: Fetch.Entity, hierarchy: hierarchy, optional: optional}
						case entry:
							e.pos.error('Duplicate field "$eKey" in ${root.toString()}, use @:component(name) or construct a NodeList manually');
					}
			}

			switch e.expr {
				case ECall(macro Parent, [e]):
					traverse(e, hierarchy.concat([Parent]), componentKey, entityKey, optional);
				case ECall(macro Linked, [ekey, e]):
					traverse(e, hierarchy.concat([Linked(ekey)]), componentKey, entityKey, optional);
				case EParenthesis(e) | ECall(_, [e]):
					traverse(e, hierarchy, componentKey, entityKey, optional);
				case EUnop(OpNot, false, e):
					traverse(e, hierarchy, componentKey, entityKey, optional);
				case EUnop(OpNegBits, false, e):
					traverse(e, hierarchy, componentKey, entityKey, true);
				case EBinop(OpBoolAnd, e1, e2):
					traverse(e1, hierarchy, componentKey, entityKey, optional);
					traverse(e2, hierarchy, componentKey, entityKey, optional);
				case EBinop(OpBoolOr, e1, e2):
					traverse(e1, hierarchy, componentKey, entityKey, optional);
					traverse(e2, hierarchy, componentKey, entityKey, true);
				case EMeta({name: ':component', params: [macro null]}, _):
				// traverse(e, hierarchy, key, entityKey, optional);
				case EMeta({name: ':component', params: [{expr: EConst(CIdent(key))}]}, e):
					traverse(e, hierarchy, key, entityKey, optional);
				case EMeta({name: ':entity', params: [{expr: EConst(CIdent(key))}]}, e):
					traverse(e, hierarchy, componentKey, key, optional);
				case EField(_, v) | EConst(CIdent(v)):
					if (componentKey == null)
						componentKey = lowerFirst(v);
					add(componentKey, entityKey);
				case _:
					e.pos.error('Unsupported expression: ${e.toString()}');
			}
		})(root, []);

		/*
			// get T from a Class<T> expr
			for (expr in map) {
				final type = haxe.macro.Context.typeof(macro {
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

private enum Fetch {
	Component(e:Expr);
	Entity;
}
