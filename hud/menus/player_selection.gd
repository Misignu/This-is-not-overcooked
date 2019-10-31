tool
extends Control

const TARGET_SCENE = "res://scenarios/level1.tscn"
var time: int setget set_time

onready var tween := $Tween
onready var timer_label := $MarginContainer/VBoxContainer/Header/TimerPanel/HBoxContainer/Label
onready var clock_player := $MarginContainer/VBoxContainer/Header/TimerPanel/HBoxContainer/ClockTimer/AnimationPlayer

func _ready():
	set_process(false)

func _input(event) -> void:
	
	if event.is_pressed():
		
		for device in Game.devices:
			verify_inputs(event, device)

# @signals
func _on_Tween_tween_completed(_object, _key):
	assert(get_tree().change_scene(TARGET_SCENE) == OK)

func _on_Panel_action_key_pressed():
	
	tween.playback_speed *= 1.5
	clock_player.playback_speed *= 1.5

func _on_Panel_action_key_released():
	
	tween.playback_speed /= 1.5
	clock_player.playback_speed /= 1.5

func _on_Panel_player_input_desattached():
	
	if not Game.has_players_selected():
		_stop_timer()
	
	update_slots()

# @main
func verify_inputs(event: InputEvent, index: int):
	
	if event.is_action_pressed(str("player", index, "_start")):
		_shift_player_selection(index)

func _shift_player_selection(index: int) -> void:
	
	var device_index: int = index
	var player_slot: int = Game.is_player_atached_to_device(device_index)
	var was_enabled: bool
	
	if player_slot < 0:
		player_slot = Game.get_availlable_player_index()
		
	else:
		was_enabled = true
	
	if not was_enabled:
		
		Game.players[player_slot].device = device_index # REFACTOR
		add_slot(player_slot, device_index)
	
	_start_timer()

func add_slot(index: int, device: int):
	
#	var counter: int = 0
#	var id: int
	var panel: PanelContainer = get_node(str("MarginContainer/VBoxContainer/HBoxContainer/Panel", index + 1))
#	var player: Game.Player
	
#	if Game.players[index] == -1:
	panel.select_availlable_character()
#
#	else:
#		panel.set_charact
	panel.atach_player_input(device, true)
	
#	for player in Game.players:
#
#		print("Player device: ", player.device)
#
#		id = player.id
#
#		if id == -1:
#			panel.select_availlable_character()
#
#		else:
#			panel.set_character(id)
#
#		panel.atach_player_input(player.device, player.is_device_atached())
#
#		counter += 1

func update_slots(): # DEBUG
	
	var counter: int = 0
	var panel: PanelContainer
	var device: int
	var id: int
	
	for player in Game.players: # WATCH
		
		panel = get_node(str("MarginContainer/VBoxContainer/HBoxContainer/Panel", counter + 1))
		device = player.device
		id = player.id
		panel.atach_player_input(device, device != 0)
		# print(id)
		
		if id >= 0:
			panel.set_character(id)
		
		counter += 1

func _start_timer():
	
	tween.stop(self, "time")
	tween.interpolate_property(self, "time", 10, 0, 10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	clock_player.play("clock")

func _stop_timer():
	
	tween.stop(self, "time")
	set_time(10)
	clock_player.stop(false)

func set_time(value):
	
	timer_label.text = str(ceil(value))
	time = value
