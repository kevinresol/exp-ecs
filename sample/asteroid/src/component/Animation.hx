package component;

import ecs.*;

class Animation extends Component {
	public var anime:graphic.IAnimatable;
	public function new(anime)
		this.anime = anime;
		
}
