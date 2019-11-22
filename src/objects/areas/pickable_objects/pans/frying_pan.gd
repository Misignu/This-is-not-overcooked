extends "res://src/objects/areas/pickable_objects/pan.gd"

func _ready():
	ingredient_target_state = Ingredient.FRIABLE

func insert_ingredient(ingredient: Ingredient) -> bool:
	var can_insert: bool
	
	if ingredient.preparation_type == Ingredient.FRIABLE:
		can_insert = .insert_ingredient(ingredient)
	
	return can_insert
