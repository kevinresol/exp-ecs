package exp.ecs;

@:autoBuild(exp.ecs.Component.build())
interface Component {
	var signature(get, never):Signature;
	function clone():Component;
}
