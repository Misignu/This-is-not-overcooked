tool
extends "res://src/objects/areas/pick_place.gd"

export(Game.ingredients_ids) var igridient_id: int = 0 setget set_ingredient_id
var ingredient: Ingredient

func _ready() -> void:
	update_ingredient_data()

# @main
func remove_object() -> PickableObject:
	
	var object: PickableObject
	
	if pos_current_object.get_child_count() == 0:
		
		object = ingredient.instance()
		object = object.grab()
		
	else:
		object = .remove_object()
	
	return object

func update_ingredient_data() -> void:
	var new_ingredient: Ingredient
	
	ingredient = Game.get_igredient_data(igridient_id)
	new_ingredient = ingredient.instance()
	$IngredientSprite.texture = new_ingredient.ingredient_label
	update()

# @setters
func set_ingredient_id(value: int) -> void:
	
	igridient_id = value
	update_ingredient_data()
