extends "res://objects/areas/pickable_objects/kitchenware.gd"
"""
Plate lida com a insersão de ingredientes em uma receita.

# TODO REFACTOR -> Esse script está num estado wet, com diversas verificações. Ele pode ser melhorado com a implementação de um sistema de receitas. Mas como esse projeto foi criado apenas casualmente, não houve necessidade para tal
"""
var hamburger = preload("res://objects/recipes/hamburger.tscn")
var current_recipe = null

func insert_ingredient(ingredient: Ingredient) -> bool:
	var can_insert := false
#	var texture: Texture
	
	if ingredient != null:
		
		if ingredient.preparation_state == 0:
			
			if current_ingredient == null:
				
				if "Bread" in ingredient.name:
					
					current_recipe = hamburger.instance()
					current_recipe.name = $Sprite/IngredientSprite.name
					$Sprite/IngredientSprite.replace_by(current_recipe)
#					texture = current_recipe.texture
					
					can_insert = true
				
			else:
				
				if "Lettuce" in ingredient.name:
					
					can_insert = current_recipe.add_ingredient(ingredient)
					ingredient.queue_free()
					
				elif "Meat" in ingredient.name:
					
					print(ingredient.name, " try to add in hamburger")
					can_insert = current_recipe.add_ingredient(ingredient)
					ingredient.queue_free()
			
			if can_insert:
				
				current_ingredient = ingredient
#				$Sprite/IngredientSprite.texture = texture
	
	return can_insert