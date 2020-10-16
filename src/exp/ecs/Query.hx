package exp.ecs;

enum Query {
	And(q1:Query, q2:Query);
	Or(q1:Query, q2:Query);
	Not(modifier:Modifier, signature:Signature);
	Optional(modifier:Modifier, signature:Signature);
	Must(modifier:Modifier, signature:Signature);
}

enum Modifier {
	Owned;
	Shared;
	Whatever;
	Parent(mod:Modifier);
}
