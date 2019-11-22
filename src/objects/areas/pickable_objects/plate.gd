extends "res://src/objects/areas/pickable_objects/kitchenware.gd"
"""
Plate é um KitchenWare que lida com a insersão de ingredientes em uma receita.

# TODO -> Impedir que ingredientes queimados sejam inseridos
# REFACTOR -> Esse script está num estado wet, com diversas verificações. Ele pode ser melhorado com a implementação de um sistema de receitas. Mas como esse projeto foi criado apenas casualmente, não houve necessidade para tal
"""
const CLEANING_TIME = 6
const HAMBURGER = preload("res://src/objects/recipes/hamburger.tscn")

var is_clean := true setget set_is_clean
var cleaning_time_left: float = CLEANING_TIME
var current_recipe: Sprite = null setget set_current_recipe

onready var dirt_sprite := $Sprite/DirtOverlay
onready var pos_recipe := $Recipe
onready var tween := $Tween

func _on_Tween_tween_completed(object, key) -> void:
	
	if object == dirt_sprite and key == ":modulate":
		_clear()

# @main
func insert_ingredient(ingredient: Ingredient) -> bool: # REFACTOR
	var can_insert: bool
	
	if is_clean and ingredient.preparation_state == Ingredient.DONE:
		
		if pos_recipe.get_child_count() == 0:
			can_insert = _create_recipe(ingredient.name)
			
		else:
			_update_recipe(ingredient.name)
			can_insert = current_recipe.add_ingredient(ingredient)
			ingredient.queue_free()
		
		if can_insert:
			current_ingredients.append(ingredient.name)
	
	return can_insert

func set_current_recipe(value: Sprite) -> void:
	
	if value == null: # WATCH -> Externalizar
		set_is_clean(false)
	
	current_recipe = value

func start_cleaning() -> void:
	
	tween.interpolate_property(
		dirt_sprite, "modulate",
		Color(1, 1, 1, cleaning_time_left / CLEANING_TIME), 
		Color.transparent, 
		cleaning_time_left, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()

func stop_cleaning(time_left: float) -> void:
	
	tween.stop(dirt_sprite, "modulate")
	cleaning_time_left = time_left

func _create_recipe(ingredient_name: String) -> bool:  # TODO -> Configurar para receber diferentes receitas
	var was_created: bool
	
	if "Bread" in ingredient_name:
		
		current_recipe = HAMBURGER.instance()
		pos_recipe.add_child(current_recipe)
		was_created = true
	
	return was_created

func _update_recipe(ingredient_name: String) -> void:
	
	for ingredient in current_recipe.ingredients:
		
		if ingredient_name in ingredient:
			current_ingredients.append(ingredient)

func _dirty() -> void:
	
	dirt_sprite.modulate = Color.white
	current_ingredients = []
	current_recipe = null
	
	if pos_recipe.get_child_count() > 0:
		pos_recipe.remove_child(pos_recipe.get_child(0))

func _clear() -> void:
	
	set_is_clean(true)
	cleaning_time_left = CLEANING_TIME

# @setters
func set_is_clean(value: bool) -> void:
	
	if value:
		
		if pos_recipe.get_child_count() == 1:
			pos_recipe.get_child(0).queue_free()
		
	else:
		_dirty()
	
	is_clean = value
