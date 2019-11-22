extends Control
"""
Qualquer nó em que esta cena esteja anexada será interrompida sempre que scape for pressionado
"""
onready var confirmation_dialog := $CanvasLayer/ConfirmationDialog

func _input(event):
	
	if event.is_action_pressed("escape"):
		
		get_parent().pause_mode = Node.PAUSE_MODE_STOP
		confirmation_dialog.visible = !get_tree().paused

# @signals
func _on_ConfirmationDialog_confirmed():
	get_tree().quit()

func _on_ConfirmationDialog_visibility_changed():
	var is_visible: bool = confirmation_dialog.visible
	
	$CanvasLayer/ColorRect.visible = is_visible
	get_tree().paused = is_visible
	
	if is_visible:
		confirmation_dialog.get_child(2).get_child(3).grab_focus() # REFACTOR -> Verificar se não existe um comando para isso
