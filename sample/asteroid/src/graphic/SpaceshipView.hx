package graphic;

#if openfl
import openfl.display.*;

class SpaceshipView extends Shape {
	public function new() {
		super();

		graphics.beginFill(0xFFFFFF);
		graphics.moveTo(10, 0);
		graphics.lineTo(-7, 7);
		graphics.lineTo(-4, 0);
		graphics.lineTo(-7, -7);
		graphics.lineTo(10, 0);
		graphics.endFill();
	}
}
#elseif luxe

import luxe.*;
class SpaceshipView extends Visual {
	public function new() {
		super({
			color: new Color(1, 1, 1, 1),
			geometry: Luxe.draw.poly({
				points: [
					new Vector(10, 0),
					new Vector(-7, 7),
					new Vector(-4, 0),
					new Vector(-7, -7),
					new Vector(10, 0),
				]
			}),
		});
	}
}
#end