extends MarginContainer
"""
Lida com interação e animação do menu
"""
var can_play

onready var new_game_player := $VBoxContainer/Control/MenuOptions/NewGame/AnimationPlayer
onready var continue_player := $VBoxContainer/Control/MenuOptions/Continue/AnimationPlayer
onready var options_player := $VBoxContainer/Control/MenuOptions/Options/AnimationPlayer

# @signals
func _on_NewGame_focus_entered():
	
	new_game_player.play("rainbow")
	
	if can_play == true:
		select()

func _on_Continue_focus_entered():
	
	continue_player.play("rainbow")
	select()

func _on_Options_focus_entered():
	
	options_player.play("rainbow")
	select()


func _on_NewGame_focus_exited():
	
	new_game_player.play("idle")
	can_play = true

func _on_Continue_focus_exited():
	continue_player.play("idle")

func _on_Options_focus_exited():
	options_player.play("idle")


func _on_NewGame_mouse_entered():
	$VBoxContainer/Control/MenuOptions/NewGame.grab_focus()

func _on_Continue_mouse_entered():
	$VBoxContainer/Control/MenuOptions/Continue.grab_focus()

func _on_Options_mouse_entered():
	$VBoxContainer/Control/MenuOptions/Options.grab_focus()

# @main
func select():
	$Select.play()
