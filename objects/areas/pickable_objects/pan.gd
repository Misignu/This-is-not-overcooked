extends "res://objects/areas/pickable_objects/kitchenware.gd"

var is_buffering: bool
var ingredient_target_state: int

func _on_Ingredient_prepare_finished(timer: Timer) -> void:
	
	$Sprite/IngredientSprite.frame = 1
	timer.disconnect("timeout", self, "_on_Ingredient_prepare_finished")

func _on_ingredient_burned():
	
	$Sprite/IngredientSprite.frame = 2


func _on_BurnBufferTimer_timeout():
	
	is_buffering = false
	
	if current_ingredient != null:
		current_ingredient.start_burning()

# @main
func transfer_ingredient(area: Area2D) : # REFACTOR -> Código gambiarroso
	
	if current_ingredient != null:
		
		if area.current_object.insert_ingredient(current_ingredient):
			
			if _remove_ingridient():
				current_ingredient = null


func prepare_ingridient(timer: Timer) -> bool:
	var can_prepare: bool
	
#	if current_ingredient != null: # TODO -> Verificar a segurança/ necessidade dessa verificação
		
	if current_ingredient.preparation_state == ingredient_target_state:
		
		assert(timer.connect("timeout", self, "_on_Ingredient_prepare_finished", [timer]) == OK)
		current_ingredient.prepare(current_ingredient.ACTIONS[ingredient_target_state], timer)
		can_prepare = true
	
	return can_prepare

func prepare_stop(timer: Timer) -> void:
	
	timer.disconnect("timeout", self, "_on_Ingredient_prepare_finished")
	current_ingredient.stop(current_ingredient.ACTIONS[ingredient_target_state], timer)


func start_buffering():
	
	print("is buffering")
	$BurnBufferTimer.start()
	is_buffering = true

func stop_buffering():
	
	print("buffer stopped")
	$BurnBufferTimer.stop()
	is_buffering = false


func burn_ingredient():
	
	assert(current_ingredient.get_node("BurnTimer").connect("timeout", self, "_on_ingredient_burned") == OK)
	current_ingredient.get_node("BurnTimer").start()

func stop_burning():
	
	current_ingredient.get_node("BurnTimer").disconnect("timeout", self, "_on_ingredient_burned")
	current_ingredient.stop_burning()
