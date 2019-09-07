extends MarginContainer
var can_play

func _ready():
	
	$HBoxContainer/VBoxContainer/MenuOptions/NewGame.grab_focus()

# @signals
func _on_NewGame_pressed():
	
	$Transition.play("out")
	OS.clipboard = "Obrigado por jogar! Ì†ΩÌ∏Å"

func _on_Continue_pressed():
	aviso()

func _on_Options_pressed():
	aviso()

func _on_Continue_focus_entered():
	select()

func _on_NewGame_focus_entered():
	if can_play == true:
		select()

func _on_Options_focus_entered():
	select()

func _on_NewGame_focus_exited():
	can_play = true

func _on_NewGame_mouse_entered():
	$HBoxContainer/VBoxContainer/MenuOptions/NewGame.grab_focus()

func _on_Continue_mouse_entered():
	$HBoxContainer/VBoxContainer/MenuOptions/Continue.grab_focus()

func _on_Options_mouse_entered():
	$HBoxContainer/VBoxContainer/MenuOptions/Options.grab_focus()

func _on_Transition_animation_finished(anim_name):
	
	if anim_name == "out":
		assert(get_tree().change_scene("res://scenarios/level0.tscn") == OK)

# @main
func aviso():
	print("Not implemented!\nThis is just for learning basic stuff folk XD")
	OS.window_minimized = true
	$NotImplementedSFX.play()

func select():
	$Select.play()
