tool
extends Area2D
"""
PickPlace é uma Area2D que permite que objetos sejam inseridos na Position2D current_object.
"""
var is_burning: bool setget set_is_burning
onready var pos_current_object := $CurrentObject

func _on_FireParticles_fire_finished() -> void:
	is_burning = false

func _on_FireParticles_fire_started() -> void:
	is_burning = true

# @main
func insert_object(object: PickableObject) -> bool:
	var was_inserted: bool
	
	if pos_current_object.get_child_count() == 0:
		
		pos_current_object.add_child(object)
		was_inserted = true
		
	elif object is Ingredient and pos_current_object.get_child(0).has_method("insert_ingredient"):
		was_inserted = pos_current_object.get_child(0).insert_ingredient(object)
	
	return was_inserted

func remove_object() -> PickableObject:
	var object: PickableObject
	
	if not is_burning and pos_current_object.get_child_count() == 1:
		
		object = pos_current_object.get_child(0)
		pos_current_object.remove_child(object)
	
	return object

# @setters
func set_is_burning(value: bool = true):
	$FireParticles.is_firing = value
