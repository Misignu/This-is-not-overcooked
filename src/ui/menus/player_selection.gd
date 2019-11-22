tool
extends Control

const SPEED_BOOST = 1.5
const MAX_TIME = 10
const NEXT_SCENE = "res://src/scenarios/level_x.tscn"
const ANIM_NAME = "clock"

var time: int setget set_time
onready var tween := $Tween
onready var timer_label := $MarginContainer/VBoxContainer/Header/TimerPanel/HBoxContainer/Label
onready var clock_player := $MarginContainer/VBoxContainer/Header/TimerPanel/HBoxContainer/ClockTimer/AnimationPlayer

func _ready() -> void:
	
	set_process(false)
	$MarginContainer/VBoxContainer/Header/InfoPanel/Label.text = str(tr("LEVEL"), " 1")

func _input(event) -> void:
	
	if event.is_pressed():
		
		for device in Game.devices:
			verify_inputs(event, device)

# @signals
func _on_Tween_tween_completed(_object, _key) -> void:
	assert(get_tree().change_scene(NEXT_SCENE) == OK)

func _on_Panel_action_key_pressed() -> void:
	
	tween.playback_speed *= SPEED_BOOST
	clock_player.playback_speed *= SPEED_BOOST

func _on_Panel_action_key_released() -> void:
	
	tween.playback_speed /= SPEED_BOOST
	clock_player.playback_speed /= SPEED_BOOST

func _on_Panel_player_input_desattached() -> void:
	
	if not Game.has_players_selected():
		_stop_timer()
	
	update_slots()

# @main
func verify_inputs(event: InputEvent, index: int) -> void:
	
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

func add_slot(index: int, device: int) -> void:
	var panel: PanelContainer = get_node(str("MarginContainer/VBoxContainer/HBoxContainer/Panel", index + 1))
	
	panel.select_availlable_character()
	panel.atach_player_input(device, true)


func update_slots() -> void:
	
	var counter: int = 0
	var panel: PanelContainer
	var device: int
	var id: int
	
	for player in Game.players:
		
		panel = get_node(str("MarginContainer/VBoxContainer/HBoxContainer/Panel", counter + 1))
		device = player.device
		id = player.id
		panel.atach_player_input(device, device != 0)
		
		if id >= 0:
			panel.set_character(id)
		
		counter += 1

func _start_timer() -> void:
	
	tween.stop(self, "time")
	tween.interpolate_property(self, "time", MAX_TIME, 0, MAX_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	clock_player.play(ANIM_NAME)

func _stop_timer() -> void:
	
	tween.stop(self, "time")
	set_time(MAX_TIME)
	clock_player.stop(false)

func set_time(value: int) -> void:
	
	timer_label.text = str(ceil(value))
	time = value
