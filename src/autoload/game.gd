tool
extends "res://src/autoload/ui.gd".Video
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
const ingredients = {
	ingredients_ids.BREAD: preload("res://src/objects/areas/pickable_objects/ingredients/bread.tscn"),
	ingredients_ids.MEAT: preload("res://src/objects/areas/pickable_objects/ingredients/meat.tscn"),
	ingredients_ids.LETTUCE: preload("res://src/objects/areas/pickable_objects/ingredients/lettuce.tscn")
}

var coins: int = 50 setget set_coins
var players := [
	Player.new(),
	Player.new(),
	Player.new(),
	Player.new()
] setget set_players

func _ready() -> void:
	
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
func set_players(new_array: Array):
	
	var player: Player
	
	for i in new_array.size(): # Re-organize the array based in if a device is atached
		player = new_array[i]
		
		if not player.is_device_atached():
		
			new_array.remove(i)
			new_array.push_back(player)
#
#	for player in new_array:
#		print("Player id: ", player.id)
	
	players = new_array

func set_coins(value: int) -> void:
	
	if value <= 0:
		
		assert(get_tree().change_scene("res://src/ui/eyecatchers/game_over.tscn") == OK)
	
	emit_signal("coins_changed", value, value < coins)
	coins = value

class Player:
	
	var id: int = -1 setget set_id
	var device: int = 0
	var character: StreamTexture
	
	func clear():
		
		device = 0
		id = -1
		character = null
	
	func set_id(value):
		
		if value < 0:
			clear()
		
		id = value
	
	func is_device_atached() -> bool:
		return device != 0
