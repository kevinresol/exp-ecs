package component;

import ecs.*;

class Animation implements Component {
	public var anime:graphic.IAnimatable;
	public function new(anime)
		this.anime = anime;
		
}
