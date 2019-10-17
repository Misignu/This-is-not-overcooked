extends "res://objects/areas/pick_place.gd"

var cached_plates := Array()

# @signals
func _on_Treadmill_plate_returned(plate: PickableObject):
	
	cached_plates.append(plate)
	
	if current_object == null:
		
		assert(.insert_object(_popget_cached_plates_back()))

# @override
func remove_object() -> PickableObject:
	var dirt_plate: PickableObject
	
	if cached_plates.size() == 0:
		dirt_plate = .remove_object()
		
	else:
		
		dirt_plate = _popget_cached_plates_back()
	
	return dirt_plate

func insert_object(_object: PickableObject) -> bool:
	return false

# @main
func _popget_cached_plates_back() -> PickableObject:
	var plate: PickableObject = cached_plates.back()
	
	plate.global_position = global_position
	plate.modulate = Color(1, 1, 1, 1)
	cached_plates.pop_back()
	
	return plate

