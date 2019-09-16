extends ColorRect

func change_reasons(giveup):
	$CenterContainer/TristeFim/Desafiado/Options/Yep/Reasons.visible = giveup
	$CenterContainer/TristeFim/Desafiado/Options/Nope/Reasons.visible = not giveup
	match (int(rand_range(0,4))):
		0:
			$CenterContainer/TristeFim/Desafiado/Options/Yep/Reasons.text = "É muita pressão vey!"
			$CenterContainer/TristeFim/Desafiado/Options/Nope/Reasons.text = "Quem você pensa que eu sou?"
		1:
			$CenterContainer/TristeFim/Desafiado/Options/Yep/Reasons.text = "Jisuiz mi zauva"
			$CenterContainer/TristeFim/Desafiado/Options/Nope/Reasons.text = "Vai encarar?"
		2:
			$CenterContainer/TristeFim/Desafiado/Options/Yep/Reasons.text = "Vou dar um tempinho..."
			$CenterContainer/TristeFim/Desafiado/Options/Nope/Reasons.text = "Só por cima do meu squardaver!"
		3:
			$CenterContainer/TristeFim/Desafiado/Options/Yep/Reasons.text = "Mais difícil que Dark Souls!!!"
			$CenterContainer/TristeFim/Desafiado/Options/Nope/Reasons.text = "Xalabaias!"
		
func _on_AnimationPlayer_animation_finished(_animation):
	$CenterContainer/TristeFim/Desafiado/Options/Yep.grab_focus()

func _on_Yep_pressed():
	assert(get_tree().change_scene("res://hud/menus/main_menu.tscn") == OK)

func _on_Nope_pressed():
	assert(get_tree().change_scene("res://scenarios/level0.tscn") == OK)

func _on_Yep_mouse_entered():
	$CenterContainer/TristeFim/Desafiado/Options/Yep.grab_focus()

func _on_Nope_mouse_entered():
	$CenterContainer/TristeFim/Desafiado/Options/Nope.grab_focus()

func _on_Yep_focus_entered():
	change_reasons(true)
	
func _on_Nope_focus_entered():
	change_reasons(false)
