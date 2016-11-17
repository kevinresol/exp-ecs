package node;

import ecs.*;
import component.*;

typedef GameNode = Node<Game>;
typedef MovementNode = Node<Position, Motion>;
typedef SpaceshipNode = Node<Spaceship>;
typedef RenderNode = Node<Position, Display>;
typedef MotionControlNode = Node<MotionControls, Position, Motion>;
typedef GunControlNode = Node<GunControls, Position, Gun>;
typedef LifetimeNode = Node<Lifetime>;