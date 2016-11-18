package graphic;

import openfl.display.*;

class BulletView extends Shape {
	public function new() {
		super();

		graphics.beginFill(0xFFFFFF);
		graphics.drawCircle(0, 0, 2);
		graphics.endFill();
	}
}