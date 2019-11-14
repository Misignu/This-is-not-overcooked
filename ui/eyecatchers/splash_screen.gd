extends ColorRect

func _on_Anim_animation_finished(_anim_name):
	add_child(load("res://ui/menus/title_screen.tscn").instance())
