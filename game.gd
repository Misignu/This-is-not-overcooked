tool
extends Node2D

signal coins_changed
signal fullscreen_mode_changed
signal volume_changed

enum ingredients_ids {
	BREAD = 0,
	MEAT = 1,
	LETTUCE = 2
}

const ingredients = {
	ingredients_ids.BREAD: preload("res://objects/areas/pickable_objects/ingredients/bread.tscn"),
	ingredients_ids.MEAT: preload("res://objects/areas/pickable_objects/ingredients/meat.tscn"),
	ingredients_ids.LETTUCE: preload("res://objects/areas/pickable_objects/ingredients/lettuce.tscn")
}

var coins: int = 50 setget set_coins

func _ready():
	
#	if OS.is_debug_build(): # Esse código somente será executado em uma edição de debugging
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().get_root().set_transparent_background(true)

func _input(event) -> void:
	
	if not Engine.is_editor_hint():
		
		if event.is_action_pressed("full_screen_mode_shift"):
			set_fullscreen()
		
		if event.is_action_pressed("decrease_volume"):
			decreade_master_volume()
		
		if event.is_action_pressed("increase_volume"):
			increase_master_volume()

# @main
func set_transparency_mode(value := false):
	
	get_tree().get_root().set_transparent_background(false)
	OS.window_per_pixel_transparency_enabled = value
	OS.window_borderless = value

func decreade_master_volume(value: float = 10):
	var new_volume =  AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))  - value
	
	set_master_volume(new_volume)

func increase_master_volume(value: float = 10):
	var new_volume =  AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))  + value
	
	set_master_volume(new_volume)

func set_master_volume(value: float):
	
	if value >= -80 and value <= 0:
		print("Volume: ", value)
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
		emit_signal("volume_changed", value)
	
#value: float = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))  - 10.0 if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))  - 10.0 >= 0 else 0.0

func set_fullscreen(mode: bool = !OS.window_fullscreen):
	
	OS.window_fullscreen = mode
	emit_signal("fullscreen_mode_changed")

# @gettets
func get_igredient_data(ingredients_id: int) -> Ingredient:
	return ingredients[ingredients_id]

# @setters
func set_coins(value: int) -> void:
	
	if value <= 0:
		
		assert(get_tree().change_scene("res://hud/eyecatchers/game_over.tscn") == OK)
	
	emit_signal("coins_changed", value, value < coins)
	coins = value