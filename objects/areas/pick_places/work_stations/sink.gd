extends "res://objects/areas/pick_places/work_station.gd"

const wash_time = 6
var wash_time_left: float = wash_time

func insert_object(object: PickableObject) -> bool: # TODO REFACTOR -> Código gambiarroso
	var can_insert = false
	
	if "Plate" in object.name:
		
		if not object.clean:
			can_insert = .insert_object(object)
	
	return can_insert

func wash_plate() -> bool:
	
	if current_object != null:
		
		current_object.start_cleaning(wash_time, wash_time_left)
		_start_working(wash_time - wash_time_left, wash_time, wash_time_left)
	
	return is_working

func stop_washing():
	
	wash_time_left = $Timer.time_left
	current_object.stop_cleaning()
	_stop_working()
