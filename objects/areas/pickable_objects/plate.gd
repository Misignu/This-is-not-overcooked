extends "res://objects/areas/pickable_objects/kitchenware.gd"
"""
Plate lida com a insersão de ingredientes em uma receita.

# TODO REFACTOR -> Esse script está num estado wet, com diversas verificações. Ele pode ser melhorado com a implementação de um sistema de receitas. Mas como esse projeto foi criado apenas casualmente, não houve necessidade para tal
"""
export var dirt_texture: Texture

var clean: float = true setget set_clean
var current_recipe = null setget set_current_recipe
var hamburger = preload("res://objects/recipes/hamburger.tscn")

func _on_Tween_tween_completed(_object, _key):
	
	set_clean(true)
	$Sprite/IngredientSprite.modulate = Color(1, 1, 1, 1)
	current_recipe = null
	current_ingredient = null

# @main
func insert_ingredient(ingredient: Ingredient) -> bool:
	var can_insert := false
#	var texture: Texture
	
	if ingredient != null and clean:
		
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
					
					can_insert = current_recipe.add_ingredient(ingredient)
					ingredient.queue_free()
			
			if can_insert:
				
				current_ingredient = ingredient
#				$Sprite/IngredientSprite.texture = texture
	
	return can_insert

func set_current_recipe(value) -> void:
	
	if value == null:
		
		$Sprite/IngredientSprite.texture = null
		set_clean(false)
	
	current_recipe = value

func start_cleaning(cleaning_time: float, cleaning_time_left: float) -> void:
	
	$Tween.interpolate_property(
		$Sprite/IngredientSprite, "modulate", 
		Color(1, 1, 1, cleaning_time_left / cleaning_time), 
		Color(1, 1, 1, 0), 
		cleaning_time_left, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.start()

func stop_cleaning() -> void:
	$Tween.stop($Sprite/IngredientSprite)

func set_clean(value) -> void:
	
	if value:
		$Sprite/IngredientSprite.texture = null
	else:
		$Sprite/IngredientSprite.texture = dirt_texture
		$Sprite/IngredientSprite.vframes = 1
		$Sprite/IngredientSprite.hframes = 1
		$Sprite/IngredientSprite.frame = 0
	
	clean = value

