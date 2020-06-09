package exp.ecs.component.e2d;

class Transform {
	static macro function set(field, value) {
		return macro {
			if ($field != $value)
				dirty = true;
			$field = $value;
		}
	}
		
}