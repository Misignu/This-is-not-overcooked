extends ColorRect

func _on_Animation_animation_finished(_anim_name):
	
	assert(get_tree().change_scene("res://ui/menus/title_screen.tscn") == OK)
