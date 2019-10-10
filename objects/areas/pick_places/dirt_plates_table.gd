extends "res://objects/areas/pick_place.gd"

var cached_plates := Array()

func _ready():
	
	if "Treadmill" in get_parent().name:
		
		get_parent().set_plates_output(self)

# @signals
func _on_Timer_timeout():
	var plate: PickableObject = cached_plates.back()
	
	plate.current_recipe = null
	
	if current_object == null:
		
		plate.position = global_position
		plate.modulate = Color(1, 1, 1, 1)
		current_object = plate
		cached_plates.pop_back()

# @main
func remove_object() -> PickableObject:
	var dirt_plate: PickableObject
	
	if cached_plates.size() == 0:
		dirt_plate = .remove_object()
		
	else:
		
		dirt_plate = cached_plates.back()
		cached_plates.pop_back()
	
	return dirt_plate

func insert_object(_object: PickableObject) -> bool:
	return false

func cache_plate(plate: PickableObject):
	
	cached_plates.append(plate)
	$Timer.start()
