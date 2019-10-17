extends MarginContainer
"""
LIda com interação e animação do menu
"""
var can_play
var current_focused: int = 0


func _input(event): # TODO REFACTOR
	
	if event.is_action_pressed("player1_move_up"):
		
		$VBoxContainer/MenuOptions.get_child(current_focused - 1 if current_focused > 0 else 2).grab_focus()
	
	if event.is_action_pressed("player1_move_down"):
		
		$VBoxContainer/MenuOptions.get_child(current_focused + 1 if current_focused < 2 else 0).grab_focus()

# @signals
func _on_NewGame_focus_entered():
	
	$VBoxContainer/MenuOptions/NewGame/AnimationPlayer.play("rainbow")
	current_focused = 0
	
	if can_play == true:
		select()

func _on_Continue_focus_entered():
	
	$VBoxContainer/MenuOptions/Continue/AnimationPlayer.play("rainbow")
	select()
	current_focused = 1

func _on_Options_focus_entered():
	
	$VBoxContainer/MenuOptions/Options/AnimationPlayer.play("rainbow")
	select()
	current_focused = 2


func _on_NewGame_focus_exited():
	$VBoxContainer/MenuOptions/NewGame/AnimationPlayer.play("idle")
	can_play = true

func _on_Continue_focus_exited():
	$VBoxContainer/MenuOptions/Continue/AnimationPlayer.play("idle")

func _on_Options_focus_exited():
	$VBoxContainer/MenuOptions/Options/AnimationPlayer.play("idle")


func _on_NewGame_mouse_entered():
	$VBoxContainer/MenuOptions/NewGame.grab_focus()

func _on_Continue_mouse_entered():
	$VBoxContainer/MenuOptions/Continue.grab_focus()

func _on_Options_mouse_entered():
	$VBoxContainer/MenuOptions/Options.grab_focus()

# @main
func select():
	$Select.play()
