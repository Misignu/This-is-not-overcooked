extends "res://objects/areas/pickable_objects/pan.gd"

func _ready():
	ingredient_target_state = Ingredient.FRIABLE

func insert_ingredient(ingredient: Ingredient) -> bool:
	var can_insert: bool = ._insert_ingredient(ingredient, ingredient.preparation_state == Ingredient.FRIABLE)
	
	if can_insert:
		
		if current_ingredient.fried_frames != null:
			
			ingredient.visible = false
			$Sprite/IngredientSprite.texture = current_ingredient.fried_frames
			
		else:
			
			push_warning(str("None fried_frames's texture defined to the Ingredient: ", current_ingredient.name))
	
	ingredient.get_node("CollisionShape2D").disabled = true
	return can_insert
