extends "res://src/objects/areas/pick_places/work_station.gd"

func insert_object(object: PickableObject) -> bool:
	var can_insert = false
	
	if "Plate" in object.name:
		
		if not object.is_clean:
			can_insert = .insert_object(object)
	
	return can_insert

func wash_plate() -> bool:
	var plate: PickableObject
	
	if pos_current_object.get_child_count() > 0:
		
		plate = pos_current_object.get_child(0)
		
		if not plate.is_clean:
			
			plate.start_cleaning()
			._start_working(
				plate.CLEANING_TIME - plate.cleaning_time_left,
				plate.CLEANING_TIME,
				plate.cleaning_time_left
			)
	
	return is_working

func stop_washing() -> void:
	
	if is_working:
		
		pos_current_object.get_child(0).stop_cleaning($WorkTimer.time_left)
		_stop_working()
