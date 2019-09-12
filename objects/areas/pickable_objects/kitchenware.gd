extends PickableObject

var current_ingredient: Ingredient

func _insert_ingredient(ingredient: Ingredient, condition: bool = true) -> bool:
	var can_insert: bool = ingredient != null and condition
	
	if condition:
		
		current_ingredient = ingredient
	
	return can_insert

func _remove_ingridient() -> Ingredient:
	var ingredient = current_ingredient
	
	$Sprite/IngredientSprite.texture = null
	current_ingredient = null
	
	return ingredient
