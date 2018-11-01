package ecs.event;

import haxe.ds.Option;

typedef EventSelector<Event:EnumValue, Data> = Event->Option<Data>;