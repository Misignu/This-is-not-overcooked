extends ColorRect

func _on_Anim_animation_finished(_anim_name):
	
	add_child(load("res://hud/menus/main_menu.tscn").instance())