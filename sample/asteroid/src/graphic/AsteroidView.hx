package graphic;

import openfl.display.*;

class AsteroidView extends Shape {
	public function new(radius:Float) {
		super();

		var angle = 0.;
		graphics.beginFill(0xFFFFFF);
		graphics.moveTo(radius, 0);
		while (angle < Math.PI * 2) {
			var length = ( 0.75 + Math.random() * 0.25 ) * radius;
			graphics.lineTo(Math.cos(angle) * length, Math.sin(angle) * length);
			angle += Math.random() * 0.5;
		}
		graphics.lineTo(radius, 0);
		graphics.endFill();
	}
}