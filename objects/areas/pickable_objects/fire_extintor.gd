extends PickableObject

func erase_fire(key: String):
	
	if Input.is_action_pressed(key):
		pass

func grab() -> PickableObject:
	
	get_parent().remove_child(self)
	position = Vector2.ZERO
	return .grab()
