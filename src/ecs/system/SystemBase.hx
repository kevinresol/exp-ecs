package ecs.system;

import ecs.*;
import ecs.node.*;
using tink.CoreApi;

interface SystemBase<Event> {
	function update(dt:Float):Void;
	function onAdded(engine:Engine<Event>):Void;
	function onRemoved(engine:Engine<Event>):Void;
}