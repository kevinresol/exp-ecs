# Experimental macro-powered ECS

### Entity

#### Entity Relationships

There are 3 ways an entity can relate to other entities:

- Inheritance
- Hierarchy
- Linkage

##### Inheritance

When an entity (derived entity) inherits another entity (base entity),
the derived entity will share all the components that the base entity has.

Each entity contains three methods to check if a particular component is available:

- `owns(signature)`: check if the entity owns by itself the specified component
- `shares(signature)`: check if the entity shares the specified component from an upstream base entity
- `has(signature)`: check if the entity has the specified component, by either owning or sharing

##### Hierarchy

A simple parent-children hierarchy where components are not shared.

##### Linkage

Allows entity to arbitrarily link to another entity using a string key where components are not shared.

### Node

A node contains a reference to an entity and other related data,
such as components that fulfill a particular Query (see below)

### NodeList

A NodeList is merely an array of Nodes. But with the `NodeList.generate(world, query)` function,
it is possible to observe the given world and create a NodeList that will update itself as
the world's entities and components change, such that the nodes in the list always fulfill the query.

### Query

Inspired by [flecs](https://github.com/SanderMertens/flecs),
exp-ecs implements a macro-based mechanism to query entities.

Here are some quick example to have a taste of it:

```haxe
// Create a NodeList which contains entities that:
// has the Transform2 component
final nodes = NodeList.generate(world, Transform2);
for(node in nodes) {
	$type(node.entity); // Entity
	$type(node.data.transform2); // Transform2
}

// Same as above but rename the field with the `@:component` metadata
final nodes = NodeList.generate(world, @:component(myTransform) Transform2);
for(node in nodes) {
	$type(node.data.myTransform); // Transform2
}

// Create a NodeList which contains entities that:
// has a linked entity named as "target" and that linked entity has the Transform2 component
final nodes = NodeList.generate(world, Linked('target', Transform2));
for(node in nodes) {
	$type(node.data.transform2); // Transform2
}

// Same as above but also create a reference to the linked entity with the `@:entity` metadata
final nodes = NodeList.generate(world, @:entity(linked) Linked('target', Transform2));
for(node in nodes) {
	$type(node.data.linked); // Entity
	$type(node.data.transform2); // Transform2
}

```
