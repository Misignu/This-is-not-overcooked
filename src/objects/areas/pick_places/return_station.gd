extends "res://src/objects/areas/pick_place.gd"

var cached_objects := Array()

# @signals
func _on_Treadmill_object_delivered(plate: PickableObject) -> void:
	_cache_object(plate)

func _on_Trash_object_delivered(object: PickableObject) -> void:
	_cache_object(object)

# @override
func remove_object() -> PickableObject:
	var dirt_plate: PickableObject
	
	if cached_objects.size() == 0:
		dirt_plate = .remove_object()
		
	else:
		dirt_plate = _popget_cached_objects_back()
	
	return dirt_plate

func insert_object(_object: PickableObject) -> bool:
	return false

# @main
func _cache_object(object: PickableObject) -> void:
	
	object.position = Vector2.ZERO # WATCH -> Verificar a necessidade dessa linha
	object.modulate = Color.white # WATCH -> Substituir por trocar visibilidade
	
	if not .insert_object(object):
		cached_objects.append(object)

func _popget_cached_objects_back() -> PickableObject:
	var object: PickableObject = cached_objects.back()
	
	cached_objects.pop_back()
	return object
