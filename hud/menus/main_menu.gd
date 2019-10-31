extends MarginContainer
"""
Lida com interação e animação do menu
"""
var can_play

onready var select_player := $Select
onready var menu_options := $VBoxContainer/MenuOptions
onready var new_game_option := $VBoxContainer/MenuOptions/NewGame
onready var continue_option := $VBoxContainer/MenuOptions/Continue
onready var options_option := $VBoxContainer/MenuOptions/Options
onready var new_game_player := $VBoxContainer/MenuOptions/NewGame/AnimationPlayer
onready var continue_player := $VBoxContainer/MenuOptions/Continue/AnimationPlayer
onready var options_player := $VBoxContainer/MenuOptions/Options/AnimationPlayer

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
	new_game_option.grab_focus()

func _on_Continue_mouse_entered():
	continue_option.grab_focus()

func _on_Options_mouse_entered():
	options_option.grab_focus()

# @main
func select():
	select_player.play()
