tool
extends Area2D

var current_object: PickableObject = null
var is_burning: bool setget set_is_burning

func _on_FireTimer_timeout():
	
	$Scan.set_physics_process(true)
	$Scan.enabled = true

func insert_object(object: PickableObject) -> bool: # WATCH -> Aparentemente resolvido
	var can_insert: bool = false
	
	if current_object == null:
		
		object.visible = true
		current_object = object
		current_object.get_node('CollisionShape2D').disabled = true
		current_object.global_position = global_position
		can_insert = true
		
	elif object is Ingredient and current_object.has_method("insert_ingredient"):
		
		can_insert = current_object.insert_ingredient(object)
	
	return can_insert

func remove_object() -> PickableObject:
	var object = current_object
	
	if current_object != null:
		object.visible = false
	
	current_object = null
	
	return object

# @setters
func set_is_burning(value := true):
	
	$FireTimer.start()
	$FireParticles.emitting = value
	$FireBSFX2D.play()
	is_burning = value
