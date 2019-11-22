extends CanvasLayer

signal game_mode_started

const NEXT_SCENE = "res://src/ui/menus/player_selection.tscn"
const ANINATION_NAME = "out"

onready var options: WindowDialog = $Options

func _ready():
	$MainMenu/VBoxContainer/Control/MenuOptions/NewGame.grab_focus()

# @signals
func _on_Transition_animation_finished(anim_name):
	
	if anim_name == ANINATION_NAME:
		
		Game.set_transparency_mode()
		emit_signal("game_mode_started", NEXT_SCENE)

func _on_NewGame_pressed():
	
	$MainMenu/Transition.play(ANINATION_NAME)
	$Audio/Music.stop()
	OS.clipboard = "Obrigado por jogar!  " # WATCH -> HACKER DEMAIS

func _on_Continue_pressed():
	
	if OS.is_debug_build():

		print("Not implemented!\nThis is just for learning basic stuff folk XD")
		OS.window_minimized = true
	
	$Audio/NotImplementedSFX.play()

func _on_Options_pressed():
	
	options.popup()
	options.focus_first()
