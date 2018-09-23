package ecs.system;

import ecs.*;
import ecs.node.*;
using tink.CoreApi;

interface SystemBase {
	function update(dt:Float):Void;
	function onAdded(engine:Engine):Void;
	function onRemoved(engine:Engine):Void;
}