tool
extends Area2D

"""
Area2D que permite que objetos sejam inseridos na Position2D CurrentObject
"""

var current_object: PickableObject = null
var is_burning: bool setget set_is_burning

onready var pos_current_object := $CurrentObject

func _on_FireParticles_fire_finished():
	is_burning = false

func _on_FireParticles_fire_started():
	is_burning = true

# @main
func insert_object(object: PickableObject) -> bool:
	var can_insert: bool = false
	
	if pos_current_object.get_child_count() != 1:
		
		if "FireExtintor" in object.name:
			
			pos_current_object.add_child(object)
			can_insert = true
			
		elif current_object == null:
			
			object.visible = true
			current_object = object
			current_object.get_node('CollisionShape2D').disabled = true
			current_object.global_position = global_position
			can_insert = true
			
		elif object is Ingredient and current_object.has_method("insert_ingredient"):
			
			can_insert = current_object.insert_ingredient(object)
	
	return can_insert

func remove_object() -> PickableObject:
	var object: PickableObject
	
	if pos_current_object.get_child_count() == 1:
		object = pos_current_object.get_child(0)
		
	elif current_object != null:
		
		current_object.visible = false
		object = current_object
	
	current_object = null
	
	return object

# @setters
func set_is_burning(value: bool = true):
	
	$FireParticles.is_firing = value
