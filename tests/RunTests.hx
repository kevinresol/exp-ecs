package;

import tink.unit.*;
import tink.testrunner.*;

class RunTests {
	static function main() {
		Runner.run(TestBatch.make([
			// @formatter:off
			new NodeListTest(),
			new EntityTest(),
			// @formatter:on
		])).handle(Runner.exit);
	}
}
