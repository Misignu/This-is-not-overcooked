extends "res://src/objects/areas/pick_place.gd"

signal object_delivered

export(float, 60) var buffer_replacement_time: float = 5
var cached_objects_to_replace := Array()

func _on_buffer_timeout(object: PickableObject, buffer: Timer) -> void:
	
	buffer.queue_free()
	cached_objects_to_replace.remove(cached_objects_to_replace.find(object))
	emit_signal("object_delivered", object)

# @main
func _buffer_delivery(object: PickableObject) -> void:
	var buffer: = Timer.new()
	
	assert(buffer.connect("timeout", self, "_on_buffer_timeout", [object, buffer]) == OK)
	add_child(buffer)
	buffer.start(buffer_replacement_time)
