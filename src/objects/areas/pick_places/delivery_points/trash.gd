extends "res://src/objects/areas/pick_places/delivery_point.gd"

func _on_Tween_tween_completed(object, key: String) -> void:
	
	if object is PickableObject and key == ":scale":
		
		if object is Ingredient:
			object.queue_free()
			
		else:
			
			_buffer_delivery(.remove_object())
			object.scale = Vector2.ONE

# @override
func insert_object(object: PickableObject) -> bool:
	var inserted = .insert_object(object)
	
	if inserted:
		
		cached_objects_to_replace.append(object)
		$Tween.interpolate_property(object, "scale", object.scale, Vector2.ZERO, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$Tween.start()
	
	return inserted

func remove_object():
	return null
