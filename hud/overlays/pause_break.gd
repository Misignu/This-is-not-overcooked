extends Control
"""
Qualquer nó em que esta cena esteja anexada será interrompida sempre que scape for pressionado
"""

func _input(event):
	
	if event.is_action_pressed("escape"):
		
		get_parent().pause_mode = Node.PAUSE_MODE_STOP
		
		$CanvasLayer/ConfirmationDialog.visible = !get_tree().paused

func _on_ConfirmationDialog_confirmed():
	get_tree().quit()


func _on_ConfirmationDialog_visibility_changed():
	var is_visible: bool = $CanvasLayer/ConfirmationDialog.visible
	
	$CanvasLayer/ColorRect.visible = is_visible
	get_tree().paused = is_visible
	
	if is_visible:
		$CanvasLayer/ConfirmationDialog.get_child(2).get_child(3).grab_focus()
