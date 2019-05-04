# Macro-powered Entity-Component-System framework

[![Build Status](https://travis-ci.org/kevinresol/ecs.svg?branch=develop)](https://travis-ci.org/kevinresol/ecs)

This is a Entity-Component-System framework, inspired by the [Ash Framework](http://www.ashframework.org/)  
Thanks to the Haxe macro system we are able to reduce boilerplate code and allow some optimizations.

This is platform-agnostic, you can use it on any targets supported by Haxe (e.g. cpp, js, lua, etc)  
This is also game-framework-agnostic, you can use it with any game frameworks such as Kha, OpenFL, Heaps, etc.

## Elements of the framework

**Engine**  
The "core" that manages everything

**Entity**  
A container holding various components

**Component**  
Building blocks of an entity, contains attributes/properties but not any logics

**System**  
Logics that operate on Components

**Node**  
A container holding an Entity and the Components of interest.
This is mostly for optimization, pre-fetching components from the entity so that we don't need to do so on every iteration.

**NodeList**  
A list of Nodes. The specialized `TrackingNodeList` will keep track of entities together with their components and add/remove them from the list when appropriate.

## Example

```haxe
import exp.ecs.*;
import exp.ecs.node.*;
import exp.ecs.entity.*;
import exp.ecs.system.*;
import component.*;
import haxe.Timer;

class Playground {
	static function main() {
		// create an engine
		var engine = new Engine();
		
		// create an entity and adds 2 components to it
		var entity = new Entity();
		entity.add(new Velocity(1, 0));
		entity.add(new Position(0, 0));
		
		// add entity to engine
		engine.entities.add(entity);
		
		// create and add 2 systems to engine
		engine.systems.add(new MovementSystem());
		engine.systems.add(new RenderSystem());
		engine.systems.add(new CustomSystem());
		
		// run the engine
		new Timer(16).run = function() engine.update(16 / 1000);
	}
}

// Use metadata `@:nodes` to create a TrackingNodeList that contains nodes of entities that contains the specified components
// NodeList created this way will be cached in the engine, i.e. multiple systems will share the same NodeList instance if their Node type is the same
class MovementSystem extends System {
	// prepares a NodeList that contains entities having both the Position and Velocity components
	@:nodes var nodes:Node<Position, Velocity>;
	
	override function update(dt:Float) {
		// on each update we iterate all the nodes and update their Position components
		for(node in nodes) {
			node.position.x += node.velocity.x * dt;
			node.position.y += node.velocity.y * dt;
		}
	}
}

class RenderSystem extends System {
	// prepares a NodeList that contains entities having the Position component
	@:nodes var nodes:Node<Position>;
	
	override function update(dt:Float) {
		// on each update we iterate all the nodes and print out their positions on screen
		for(node in nodes) {
			trace('${node.entity} @ ${node.position.x}, ${node.position.y}');
		}
	}
}

// Besides using `@:nodes`, you can also create a NodeList manually
class CustomSystem extends System {
	var nodes:NodeList<CustomNode>;
	
	override function update(dt:Float) {
		for(node in nodes) {
			$type(node); // CustomNode
		}
	}
	
	override function onAdded(engine) {
		super.onAdded(engine);
		nodes = new TrackingNodeList(engine, CustomNode.new, entity -> entity.has(Position));
	}
	
	override function onRemoved(engine) {
		super.onRemoved(engine);
		nodes = null;
	}
}

// Manually declare a Node type
class CustomNode implements NodeBase {
	public var entity(default, null):Entity;
	public function new(entity) this.entity = entity;
}
```
