extends "res://objects/areas/pickable_objects/kitchenware.gd"

func _on_fry_finished(timer: Timer):
	
	$Sprite/IngredientSprite.frame = 1
	timer.disconnect("timeout", self, "_on_fry_finished")

func _on_ingredient_burned():
	
	$Sprite/IngredientSprite.frame = 2

# @main
func insert_ingredient(ingredient: Ingredient) -> bool:
	var can_insert: bool = ._insert_ingredient(ingredient, ingredient.preparation_state == Ingredient.FRIABLE)
	
	if can_insert:
		
		if current_ingredient.fried_frames != null:
			
			$Sprite/IngredientSprite.texture = current_ingredient.fried_frames
			
		else:
			
			push_warning(str("None fried_frames's texture defined to the Ingredient: ", current_ingredient.name))
	
	ingredient.get_node("CollisionShape2D").disabled = true
	return can_insert

func transfer_ingredient(area: Area2D) : # TODO REFACTOR -> Código gambiarroso
	
	if current_ingredient != null:
		
		if area.current_object.insert_ingredient(current_ingredient):
			
			if _remove_ingridient():
				current_ingredient = null

func fry_ingridient(timer: Timer) -> bool:
	var can_fry = false
	
	if current_ingredient != null and current_ingredient.preparation_state == Ingredient.FRIABLE:
		
		assert(timer.connect("timeout", self, "_on_fry_finished", [timer]) == OK)
		current_ingredient.prepare("fry", timer)
		
		can_fry = true
	
	return can_fry

func stop(timer: Timer):
	
	current_ingredient.stop("fry", timer)

func burn_ingredient():
	
	assert(current_ingredient.get_node("BurnTimer").connect("timeout", self, "_on_ingredient_burned") == OK)
	current_ingredient.get_node("BurnTimer").start()

func stop_burning():
	
	current_ingredient.get_node("BurnTimer").stop()
	current_ingredient.get_node("BurnTimer").disconnect("timeout", self, "_on_ingredient_burned")
