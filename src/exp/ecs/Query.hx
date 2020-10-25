package exp.ecs;

@:using(exp.ecs.Query.QueryTools)
enum Query {
	And(q1:Query, q2:Query);
	Or(q1:Query, q2:Query);
	Component(condition:Condition, modifier:Modifier, signature:Signature);
}

enum abstract Condition(Int) {
	final Not;
	final Optional;
	final Must;
	public function toSymbol() {
		return switch (cast this : Condition) {
			case Not: '!';
			case Optional: '~';
			case Must: '';
		}
	}
}

enum Modifier {
	Owned;
	Shared;
	Whatever;
	Parent(mod:Modifier);
	Linked(key:String, mod:Modifier);
}

class QueryTools {
	public static inline function toString(query:Query) {
		return printQuery(query);
	}

	static function printQuery(query:Query) {
		return switch query {
			case And(q1, q2):
				'(${printQuery(q1)} && ${printQuery(q2)})';
			case Or(q1, q2):
				'(${printQuery(q1)} || ${printQuery(q2)})';
			case Component(condition, modifier, signature):
				'${condition.toSymbol()}${printModifier(modifier)}:${signature.toString().split('.').pop()}';
		}
	}

	static function printModifier(mod:Modifier) {
		return switch mod {
			case Owned: 'Owned';
			case Shared: 'Shared';
			case Whatever: 'Whatever';
			case Parent(sub): 'Parent(${printModifier(sub)})';
			case Linked(key, sub): 'Linked(${key.split('.').pop()}, ${printModifier(sub)})';
		}
	}
}
