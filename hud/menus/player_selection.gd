tool
extends Control

const JOIN_THE_PARTY = "Press Start\nto join the party"
const BOOST_THE_TIMER = "Hold Start\nto Boost the Timer"

func _ready():
	set_process(false)

func _input(event) -> void:
	
	if event.is_pressed():
		
		for device in Game.devices:
			verify_inputs(event, device)

func _process(_delta):
	$MarginContainer/VBoxContainer/Header/TimerPanel/HBoxContainer/Label.text = str(ceil($Timer.time_left))

# @signals
func _on_Timer_timeout():
	assert(get_tree().change_scene("res://scenarios/level1.tscn") == OK)

# @main
func verify_inputs(event: InputEvent, index: int):
	
	if event.is_action_pressed(str("player", index, "_start")):
		
		_shift_player_selection(index, true)
	
	if event.is_action_pressed(str("player", index, "_secoundary_action")):
		_shift_player_selection(index, false)

func _shift_player_selection(index: int, enable: bool) -> void:
	
	var device_index: int = index
	var player_slot: int = Game.is_player_atached_to_device(device_index)
	var new_label_text: String = JOIN_THE_PARTY
	var was_enabled: bool
	var panel: PanelContainer
	
	if player_slot < 0:
		
		player_slot = Game.get_availlable_player_index()
		
		if enable:
			new_label_text = BOOST_THE_TIMER
		
	else:
		
		if not enable:
			
			device_index = 0
			new_label_text = JOIN_THE_PARTY
			
		else:
			was_enabled = true
	
	if not was_enabled:
		
		Game.players[player_slot].device = device_index
		panel = get_node(str("MarginContainer/VBoxContainer/HBoxContainer/Panel", player_slot + 1))
		panel.atach_player_input(index, enable)
		panel.get_node("MarginContainer/VBoxContainer/CenterContainer/Label").text = new_label_text
	
	_reset_timer(enable)

func _reset_timer(play: bool):
	
	if play:
		
		$Timer.start()
		set_process(true)
		
	elif not Game.has_players_selected():
		
		set_process(false)
		$Timer.stop()
		$MarginContainer/VBoxContainer/Header/TimerPanel/HBoxContainer/Label.text = str($Timer.wait_time)
