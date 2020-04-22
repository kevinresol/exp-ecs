package exp.ecs.system;

import exp.ecs.*;
import exp.ecs.node.*;
using tink.CoreApi;

interface SystemBase<Event> {
	function update(dt:Float):Void;
	function onAdded(engine:Engine<Event>):Void;
	function onRemoved(engine:Engine<Event>):Void;
	function destroy():Void;
}