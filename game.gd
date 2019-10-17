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
			decrease_volume()
		
		if event.is_action_pressed("increase_volume"):
			increase_volume()

# @gettets
func get_igredient_data(ingredients_id: int) -> Ingredient:
	return ingredients[ingredients_id]

# @setters
func set_coins(value: int) -> void:
	
	if value <= 0:
		
		assert(get_tree().change_scene("res://hud/eyecatchers/game_over.tscn") == OK)
	
	emit_signal("coins_changed", value, value < coins)
	coins = value

