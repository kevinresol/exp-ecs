package ecs.event;

import haxe.ds.Option;

typedef Selector<Event:EnumValue, Data> = Event->Option<Data>;