extends MarginContainer
var can_play

func _ready():
	
	assert(Game.connect("fullscreen_mode_changed", self, "_on_Game_fullscreen_mode_changed") == OK)
	$HBoxContainer/VBoxContainer/MenuOptions/NewGame.grab_focus()

# @signals
func _on_Game_fullscreen_mode_changed():
	get_parent().get_node("OptionsPopup/MarginContainer/VBoxContainer/CheckBox").pressed = OS.window_fullscreen

func _on_NewGame_focus_entered():
	$HBoxContainer/VBoxContainer/MenuOptions/NewGame/AnimationPlayer.play("rainbow")
	
	if can_play == true:
		select()

func _on_Continue_focus_entered():
	$HBoxContainer/VBoxContainer/MenuOptions/Continue/AnimationPlayer.play("rainbow")
	select()

func _on_Options_focus_entered():
	$HBoxContainer/VBoxContainer/MenuOptions/Options/AnimationPlayer.play("rainbow")
	select()

func _on_NewGame_focus_exited():
	$HBoxContainer/VBoxContainer/MenuOptions/NewGame/AnimationPlayer.play("idle")
	can_play = true

func _on_Continue_focus_exited():
	$HBoxContainer/VBoxContainer/MenuOptions/Continue/AnimationPlayer.play("idle")

func _on_Options_focus_exited():
	$HBoxContainer/VBoxContainer/MenuOptions/Options/AnimationPlayer.play("idle")

func _on_NewGame_mouse_entered():
	$HBoxContainer/VBoxContainer/MenuOptions/NewGame.grab_focus()

func _on_Continue_mouse_entered():
	$HBoxContainer/VBoxContainer/MenuOptions/Continue.grab_focus()

func _on_Options_mouse_entered():
	$HBoxContainer/VBoxContainer/MenuOptions/Options.grab_focus()

func _on_NewGame_pressed():
	
	$Transition.play("out")
	$Music.stop()
	OS.clipboard = "Obrigado por jogar! Ì†ΩÌ∏Å"

func _on_Continue_pressed():
	aviso()

func _on_Options_pressed():
	get_parent().get_node("OptionsPopup").popup()
	get_parent().get_node("OptionsPopup/MarginContainer/VBoxContainer/CheckBox").pressed = OS.window_fullscreen
	get_parent().get_node("OptionsPopup/MarginContainer/VBoxContainer/CheckBox").grab_focus()

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

func _on_CheckBox_pressed():
	
	Game.set_fullscreen()
