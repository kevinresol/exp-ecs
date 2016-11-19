package graphic;

import util.*;

#if openfl
import openfl.display.*;
#elseif luxe
import luxe.*;
#end

class SpaceshipDeathView extends #if openfl Sprite #elseif luxe Visual #end implements IAnimatable {
	var shape1:#if openfl Shape #elseif luxe Visual #end;
	var shape2:#if openfl Shape #elseif luxe Visual #end;
	var vel1:Point;
	var vel2:Point;
	var rot1:Float;
	var rot2:Float;

	public function new() {
		
		
		#if openfl
		super();
		shape1 = new Shape();
		shape1.graphics.beginFill(0xFFFFFF);
		shape1.graphics.moveTo(10, 0);
		shape1.graphics.lineTo(-7, 7);
		shape1.graphics.lineTo(-4, 0);
		shape1.graphics.lineTo(10, 0);
		shape1.graphics.endFill();
		addChild(shape1);

		shape2 = new Shape();
		shape2.graphics.beginFill(0xFFFFFF);
		shape2.graphics.moveTo(10, 0);
		shape2.graphics.lineTo(-7, -7);
		shape2.graphics.lineTo(-4, 0);
		shape2.graphics.lineTo(10, 0);
		shape2.graphics.endFill();
		addChild(shape2);
		
		#elseif luxe
		super({
			no_geometry: true,
		});
		shape1 = new Visual({
			parent: this,
			color: new Color(1, 1, 1, 1),
			geometry: Luxe.draw.poly({
				points: [
					new Vector (10, 0),
					new Vector (-7, 7),
					new Vector (-4, 0),
					new Vector (10, 0),
				]
			})
		});
		shape2 = new Visual({
			parent: this,
			color: new Color(1, 1, 1, 1),
			geometry: Luxe.draw.poly({
				points: [
					new Vector (10, 0),
					new Vector (-7, -7),
					new Vector (-4, 0),
					new Vector (10, 0),
				]
			})
		});
		
		#end

		vel1 = new Point(Math.random() * 10 - 5, Math.random() * 10 + 10);
		vel2 = new Point(Math.random() * 10 - 5, -( Math.random() * 10 + 10 ));

		rot1 = Math.random() * 300 - 150;
		rot2 = Math.random() * 300 - 150;
	}

	public function animate(time:Float):Void {
		#if openfl shape1.x #elseif luxe shape1.pos.x #end += vel1.x * time;
		#if openfl shape1.y #elseif luxe shape1.pos.y #end += vel1.y * time;
		#if openfl shape1.rotation #elseif luxe shape1.rotation_z #end += rot1 * time;
		#if openfl shape2.x #elseif luxe shape2.pos.x #end += vel2.x * time;
		#if openfl shape2.y #elseif luxe shape2.pos.y #end += vel2.y * time;
		#if openfl shape2.rotation #elseif luxe shape2.rotation_z #end += rot2 * time;
	}
	
	#if luxe
	override function set_visible(v) {
		shape1.visible = shape2.visible = v;
		return super.set_visible(v);
	}
	#end
}