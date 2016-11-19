package graphic;

#if openfl
import openfl.display.*;

class BulletView extends Shape {
	public function new() {
		super();

		graphics.beginFill(0xFFFFFF);
		graphics.drawCircle(0, 0, 2);
		graphics.endFill();
	}
}

#elseif luxe
import luxe.*;
class BulletView extends Visual {
	public function new() {
		super({
			color: new Color(1, 1, 1, 1),
			geometry: Luxe.draw.circle({
				x: -1,
				y: -1,
				r: 2,
			}),
		});
	}
}
#end