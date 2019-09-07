tool
extends Area2D

var current_object: PickableObject = null

func insert_object(object: PickableObject) -> bool: # WATCH -> Aparentemente resolvido
	var can_insert: bool = false
	
	
	if current_object == null:
		
		object.visible = true
		current_object = object
		current_object.get_node('CollisionShape2D').disabled = true
		current_object.position = position
		can_insert = true
	
	$Zom/Label.text = str(current_object) if current_object != null else ""
	return can_insert

func remove_object() -> PickableObject:
	var object = current_object
	
	if current_object:
		
		object.visible = false
		current_object.get_node('CollisionShape2D').disabled = false
	
	current_object = null
	$Zom/Label.text = str(current_object) if current_object != null else ""
	return object


