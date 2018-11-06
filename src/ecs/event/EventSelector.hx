package ecs.event;

import haxe.ds.Option;

typedef EventSelector<Event, Data> = Event->Option<Data>;