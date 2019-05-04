package component;

import exp.ecs.component.*;

class Animation extends Component {
	public var anime:graphic.IAnimatable;
	public function new(anime)
		this.anime = anime;
		
}
