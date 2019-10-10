extends "res://objects/areas/pick_place.gd"

signal recipe_delived

var plates_output: Area2D setget set_plates_output

func _on_Tween_tween_completed(object, _key):
	
	Game.coins += object.current_recipe.price
	plates_output.cache_plate(current_object)
	current_object = null
	emit_signal("recipe_delived")

# @main
func insert_object(object: PickableObject) -> bool: # TODO REFACTOR -> Código gambiarroso
	var can_insert = false
	
	if "Plate" in object.name:
		
		if object.current_recipe != null:
			
			if object.current_recipe.frame == 3:
				
				can_insert = .insert_object(object)
	
	if can_insert:
		_delivery_animation(object)
	
	return can_insert

func _delivery_animation(plate: PickableObject):
	
	$Tween.interpolate_property(plate, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$AudioStreamPlayer.play()
	$Tween.start()
	emit_signal("recipe_delived")

# @setters
func set_plates_output(area: Area2D) -> void:
	plates_output = area
