tool
extends "res://objects/areas/pick_place.gd"

export(Game.ingredients_ids) var igridient_id: int = 0 setget set_ingredient_id
var ingredient: Ingredient

func _ready():
	update_ingredient_data()

func remove_object() -> PickableObject:
	var object: PickableObject
	
	if current_object == null:
		var new_ingredient = ingredient.instance()
		
		new_ingredient.position = global_position
		get_parent().get_parent().add_child(new_ingredient)
		
		object = new_ingredient
		
	else:
		object = .remove_object()
	
	return object

func update_ingredient_data():
	var new_ingredient: Ingredient
	
	ingredient = Game.get_igredient_data(igridient_id)
	new_ingredient = ingredient.instance()
	$IngredientSprite.texture = new_ingredient.ingredient_label
	update()

# @setters
func set_ingredient_id(value: int) -> void:
	
	igridient_id = value
	update_ingredient_data()
