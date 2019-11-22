extends ColorRect

onready var yep_button := $CenterContainer/TristeFim/Desafiado/Options/Yep

func _on_AnimationPlayer_animation_finished(_animation) -> void:
	yep_button.grab_focus()

func _on_Yep_pressed() -> void:
	assert(get_tree().change_scene("res://src/ui/eyecatchers/splash_screen.tscn") == OK)

func _on_Nope_pressed() -> void:
	assert(get_tree().change_scene("res://src/scenarios/level_x.tscn") == OK)

func _on_Yep_mouse_entered() -> void:
	yep_button.grab_focus()

func _on_Nope_mouse_entered() -> void:
	$CenterContainer/TristeFim/Desafiado/Options/Nope.grab_focus()

func _on_Yep_focus_entered() -> void:
	change_reasons(true)
	
func _on_Nope_focus_entered() -> void:
	change_reasons(false)

# @main
func change_reasons(giveup: bool):
	
	var yep_label := $CenterContainer/TristeFim/Desafiado/Options/Yep/Reasons
	var nope_label := $CenterContainer/TristeFim/Desafiado/Options/Nope/Reasons
	
	yep_label.visible = giveup
	nope_label.visible = not giveup
	
	if giveup:
		yep_label.text = tr(str("YEP_REASON", int(rand_range(1, 5))))
		
	else:
		nope_label.text = tr(str("NOPE_REASON", int(rand_range(1, 5))))
