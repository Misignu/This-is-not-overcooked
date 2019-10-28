tool
extends "res://ui.gd".Video
"""
Singleton that deals with this Game General data and behaviors
"""
signal coins_changed

enum ingredients_ids {
	BREAD = 0,
	MEAT = 1,
	LETTUCE = 2
}

const devices = [-2, -1, 1, 2, 3]
const ingredients = { # WATCH -> Verificar a possibilidade de usá-los como classes globais
	ingredients_ids.BREAD: preload("res://objects/areas/pickable_objects/ingredients/bread.tscn"),
	ingredients_ids.MEAT: preload("res://objects/areas/pickable_objects/ingredients/meat.tscn"),
	ingredients_ids.LETTUCE: preload("res://objects/areas/pickable_objects/ingredients/lettuce.tscn")
}

var players := [
	Player.new(),
	Player.new(),
	Player.new(),
	Player.new()
] setget set_players
var coins: int = 50 setget set_coins

func _ready():
#	if OS.is_debug_build(): # Esse código somente será executado em uma edição de debugging
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().get_root().set_transparent_background(true)
	assert(Input.connect("joy_connection_changed", self, "_on_joy_connection_changed") == OK)

func _input(event: InputEvent) -> void:
	
	if not Engine.is_editor_hint():
		
		if event.is_action_pressed("full_screen_mode_shift"):
			set_fullscreen()
		
		if event.is_action_pressed("decrease_volume"):
			decrease_volume()
		
		if event.is_action_pressed("increase_volume"):
			increase_volume()

# @signals
func _on_joy_connection_changed(device_id, is_connected): # TODO -> Implementar atualização de Players devices
	
	print(device_id)
	
	if is_connected:
		
		print(Input.get_joy_name(device_id))
		
	else:
		print("Keyboard")

# @main
func has_players_selected() -> bool:
	var value := false
	
	for player in players:
		
		if player.is_device_atached():
			
			value = true
			break
	
	return value

func is_player_atached_to_device(index: int) -> int:
	var player_index: int = -1
	
	for i in range(players.size()):
		
		if players[i].device == index:
			
			player_index = i
			break
	
	return player_index

func get_availlable_player_index() -> int:
	var value: int
	
	for i in range(players.size()):
		
		if not players[i].is_device_atached():
			
			value = i
			break
	
	return value

# @gettets
func get_igredient_data(ingredients_id: int) -> Ingredient:
	return ingredients[ingredients_id]

# @setters
func set_players(value):
#
#	for player in value:
#		print("Player device: ", player.device)
	
	players = value

func set_coins(value: int) -> void:
	
	if value <= 0:
		
		assert(get_tree().change_scene("res://hud/eyecatchers/game_over.tscn") == OK)
	
	emit_signal("coins_changed", value, value < coins)
	coins = value

class Player:
	
	var device: int = 0 setget set_device
	var character: StreamTexture setget set_character
	
	func is_device_atached() -> bool:
		return device != 0
	
	# @setters
	func set_device(value: int) -> void:
		device = value
	
	func set_character(value: StreamTexture) -> void:
		character = value
