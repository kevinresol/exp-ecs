package ;

import exp.ecs.*;
import exp.ecs.entity.*;
import exp.ecs.component.*;
import exp.ecs.system.*;
import exp.ecs.state.*;
import exp.ecs.node.*;
import exp.fsm.*;
import component.*;
import node.*;
import system.*;
import haxe.*;

import tink.unit.*;
import tink.testrunner.*;

using StringTools;
using tink.CoreApi;

class RunTests {
	static function main() {
		Runner.run(TestBatch.make([
			new EngineTest(),
			new StateMachineTest(),
			new NodeListTest(),
			new NodeTest(),
			new SystemTest(),
			new e2d.PositionTest(),
			new EngineBenchmark(),
			new NodeListBenchmark(),
		])).handle(Runner.exit);
	}
}
