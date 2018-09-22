# Macro-powered Entity-Component-System framework

This is a Entity-Component-System game framework, inspired by the [Ash Framework](http://www.ashframework.org/)

Thanks to the Haxe macro system we are able to reduce boilerplate code and allow some optimizations.

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
A list of Nodes

## Example

```haxe
import ecs.*;
import ecs.node.*;
import ecs.entity.*;
import ecs.system.*;
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
		engine.addEntity(entity);
		
		// create and add 2 systems to engine
		engine.addSystem(new MovementSystem());
		engine.addSystem(new RenderSystem());
		
		// run the engine
		new Timer(16).run = function() engine.update(16 / 1000);
	}
}

// NodeListSystem is a System that automatically manage the required NodeList
// use metadata `@:nodes` to indicate the Nodes of interest
class MovementSystem extends NodeListSystem {
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

class RenderSystem extends NodeListSystem {
	// prepares a NodeList that contains entities having the Position component
	@:nodes var nodes:Node<Position>;
	
	override function update(dt:Float) {
		// on each update we iterate all the nodes and print out their positions on screen
		for(node in nodes) {
			trace('${node.entity} @ ${node.position.x}, ${node.position.y}');
		}
	}
}
```