package node;

import ecs.Node;
import component.*;

typedef GameNode2 = Node<Position, State<Direction2>>;


enum Direction2 {
	Forward; Backward;
}