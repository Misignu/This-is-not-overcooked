extends "res://objects/areas/pickable_objects/kitchenware.gd"
"""
Plate lida com a insersão de ingredientes em uma receita.

# REFACTOR -> Esse script está num estado wet, com diversas verificações. Ele pode ser melhorado com a implementação de um sistema de receitas. Mas como esse projeto foi criado apenas casualmente, não houve necessidade para tal
"""
const CLEANING_TIME = 6

export var dirt_texture: Texture

var is_clean: float = true setget set_is_clean
var current_recipe = null setget set_current_recipe
var hamburger = preload("res://objects/recipes/hamburger.tscn")
var cleaning_time_left: float = CLEANING_TIME

onready var ingredient_sprite: Sprite = $Sprite/IngredientSprite
onready var tween := $Tween

func _on_Tween_tween_completed(_object, _key) -> void:
	
	set_is_clean(true)
	ingredient_sprite.modulate = Color(1, 1, 1, 1) # WATCH -> Repeated statemant @ treadmil?
	current_recipe = null
	current_ingredient = null
	cleaning_time_left = CLEANING_TIME

# @main
func insert_ingredient(ingredient: Ingredient) -> bool:
	var can_insert := false
#	var texture: Texture
	
	if ingredient != null and is_clean:
		
		if ingredient.preparation_state == 0:
			
			if current_ingredient == null:
				
				if "Bread" in ingredient.name:
					
					current_recipe = hamburger.instance() # WATCH -> Is this the beste way to do it?
					ingredient_sprite.replace_by(current_recipe)
					ingredient_sprite = current_recipe
					
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
	
	return can_insert

func set_current_recipe(value) -> void:
	
	if value == null:
		
		ingredient_sprite.texture = null
		set_is_clean(false)
	
	current_recipe = value

func start_cleaning() -> void:
	
	tween.interpolate_property(
		ingredient_sprite, "modulate",
		Color(1, 1, 1, cleaning_time_left / CLEANING_TIME), 
		Color(1, 1, 1, 0), 
		cleaning_time_left, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()

func stop_cleaning(time_left: float) -> void:
	
	tween.stop(ingredient_sprite)
	cleaning_time_left = time_left

# @setters
func set_is_clean(value) -> void:
	
	if value:
		ingredient_sprite.texture = null
		
	else:
		ingredient_sprite.texture = dirt_texture
		ingredient_sprite.vframes = 1
		ingredient_sprite.hframes = 1
		ingredient_sprite.frame = 0
	
	is_clean = value
