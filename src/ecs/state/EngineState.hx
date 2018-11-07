package ecs.state;

import ecs.system.*;

typedef EngineState<Event> = State<SystemInfo<Event>>;

typedef SystemInfo<Event> = {system:System<Event>, ?before:SystemId, ?after:SystemId, ?id:SystemId}
