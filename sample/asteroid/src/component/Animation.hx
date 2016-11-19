package component;

import ecs.component.*;

class Animation extends Component {
	public var anime:graphic.IAnimatable;
	public function new(anime)
		this.anime = anime;
		
}
