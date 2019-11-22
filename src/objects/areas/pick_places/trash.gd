extends "res://src/objects/areas/pick_place.gd"

signal object_replaced

const BUFFER_REPLACEMENT_TIME = 5
var cached_objects_to_replace := Array()

func _on_Tween_tween_completed(object, key: String) -> void:
	
	if object is PickableObject and key == ":scale":
		
		if object is Ingredient:
			object.queue_free()
			
		else:
			
			_buffer_replacement(.remove_object())
			object.scale = Vector2.ONE

func _on_buffer_timeout(object: PickableObject, buffer: Timer) -> void:
	
	buffer.queue_free()
	cached_objects_to_replace.remove(cached_objects_to_replace.find(object))
	emit_signal("object_replaced", object)

# @override
func insert_object(object: PickableObject) -> bool:
	var inserted = .insert_object(object)
	
	if inserted:
		$Tween.interpolate_property(object, "scale", object.scale, Vector2.ZERO, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$Tween.start()
	
	return inserted

func remove_object():
	return null

# @main
func _buffer_replacement(object: PickableObject) -> void:
	var buffer: = Timer.new()
	
	buffer.connect("timeout", self, "_on_buffer_timeout", [object, buffer])
	add_child(buffer)
	buffer.start(BUFFER_REPLACEMENT_TIME)
