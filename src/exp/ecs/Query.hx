package exp.ecs;

enum Query {
	And(q1:Query, q2:Query);
	Or(q1:Query, q2:Query);
	Component(condition:Condition, modifier:Modifier, signature:Signature);
}

enum abstract Condition(Int) {
	final Not;
	final Optional;
	final Must;
}

enum Modifier {
	Owned;
	Shared;
	Whatever;
	Parent(mod:Modifier);
}
