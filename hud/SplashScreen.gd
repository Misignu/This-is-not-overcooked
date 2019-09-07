extends ColorRect

func _on_Anim_animation_finished(anim_name):
	
	add_child(load("res://hud/MainMenu.tscn").instance())
#	add_child(load("res://scenarios/level0.tscn").instance())
	