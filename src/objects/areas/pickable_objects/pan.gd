extends "res://src/objects/areas/pickable_objects/kitchenware.gd"

signal buffer_finished

var is_buffering: bool
var ingredient_target_state: int

func _on_BurnBufferTimer_timeout() -> void:
	
	is_buffering = false
	
	if $Recipe.get_child_count() == 1: # REFACTOR -> Impedir que timer continue rodando se não houver uma receita
		$Recipe.get_child(0).start_burning()

# @override
func grab() -> PickableObject:
	
	if is_buffering:
		stop_buffering()
	
	return .grab()

func insert_ingredient(ingredient: Ingredient) -> bool:
	var inserted: bool
	
	if $Recipe.get_child_count() == 0:
		
		$Recipe.add_child(ingredient)
		assert(connect("buffer_finished", ingredient, "start_burning") == OK)
		ingredient._change_ingridient_sprite("fried_frames", 0)
		inserted = true
	
	return inserted

# @main
func transfer_ingredient(area: Area2D) -> bool:
	
	var ingredient: PickableObject
	var was_transfered: bool
	
	if $Recipe.get_child_count() == 1:
		
		ingredient = remove_ingridient()
		
		if area.has_method("insert_ingredient"):
			was_transfered = area.insert_ingredient(ingredient)
		
		if not was_transfered:
			.insert_ingredient(ingredient)
	
	return was_transfered

func prepare_ingridient(timer: Timer) -> bool:
	var can_prepare: bool
	var recipe = $Recipe.get_child(0)
	
#	if $Recipe.get_child_count() == 1: # TODO -> Verificar a segurança/ necessidade dessa verificação
		
	if recipe.preparation_state == ingredient_target_state:
		
		recipe.prepare(recipe.ACTIONS[ingredient_target_state], timer)
		can_prepare = true
	
	return can_prepare

func prepare_stop(timer: Timer) -> void:
	var recipe = $Recipe.get_child(0)
	
	timer.disconnect("timeout", self, "_on_Ingredient_prepare_finished")
	recipe.stop(recipe.ACTIONS[ingredient_target_state], timer)


func start_buffering() -> void:
	
	$BurnBufferTimer.start()
	is_buffering = true

func stop_buffering() -> void:
	
	$BurnBufferTimer.stop()
	is_buffering = false

func burn_ingredient() -> void:
	
	emit_signal("buffer_finished")
	$Recipe.get_child(0).get_node("BurnTimer").start()

func stop_burning() -> void:
	
	$Recipe.get_child(0).stop_burning()
