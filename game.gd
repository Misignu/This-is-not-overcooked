tool
extends Node2D

signal coins_changed
signal fullscreen_mode_changed

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

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

func _input(event) -> void:
	
	if not Engine.is_editor_hint():
		
		if event.is_action_pressed("full_screen_mode_shift"):
			set_fullscreen()

# @main
func set_fullscreen(mode: bool = !OS.window_fullscreen):
	
	OS.window_fullscreen = mode
	emit_signal("fullscreen_mode_changed")

# @gettets
func get_igredient_data(ingredients_id: int) -> Ingredient:
	return ingredients[ingredients_id]

# @setters
func set_coins(value: int) -> void:
	
	if value <= 0:
		
		assert(get_tree().change_scene("res://hud/game_over.tscn") == OK)
	
	emit_signal("coins_changed", value, value < coins)
	coins = value