tool
extends Node2D

enum ingredients_ids {
	BREAD = 0,
	MEAT = 1,
	LETTUCE = 2
}

const ingredients = {
	ingredients_ids.BREAD: preload("res://objects/pickable_objects/ingredients/bread.tscn"),
	ingredients_ids.MEAT: preload("res://objects/pickable_objects/ingredients/meat.tscn"),
	ingredients_ids.LETTUCE: preload("res://objects/pickable_objects/ingredients/lettuce.tscn")
}

func _input(event):
	
	if not Engine.is_editor_hint():
		
		if event.is_action_pressed("full_screen_mode_shift"):
			OS.window_fullscreen = !OS.window_fullscreen

func get_igredient_data(ingredients_id: int) -> Ingredient:
	return ingredients[ingredients_id]
