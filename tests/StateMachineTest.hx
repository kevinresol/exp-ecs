package;

import Types;
import exp.ecs.entity.*;
import exp.ecs.state.*;
import exp.fsm.*;

@:asserts
class StateMachineTest extends Base {
	public function fsm() {
		var entity = new Entity();
		
		var forwardVelocity = new Velocity(1, 0);
		var backwardVelocity = new Velocity(-1, 0);
		
		var fsm = StateMachine.create([
			new EntityState('forward', ['backward'], entity, [forwardVelocity]),
			new EntityState('backward', ['forward'], entity, [backwardVelocity]),
		]);
		
		asserts.assert(entity.get(Velocity) == forwardVelocity, 'entity.get(Velocity) == forwardVelocity');
		
		fsm.transit('backward');
		asserts.assert(entity.get(Velocity) == backwardVelocity, 'entity.get(Velocity) == backwardVelocity');
		
		fsm.transit('forward');
		asserts.assert(entity.get(Velocity) == forwardVelocity, 'entity.get(Velocity) == forwardVelocity');
		
		
		return asserts.done();
	}
	
	inline function equals<T>(v1:T, v2:T)
		return v1 == v2;
}