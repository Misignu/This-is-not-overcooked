extends "res://objects/areas/pick_places/work_station.gd"

func _on_Timer_timeout():
	stop_washing()

func insert_object(object: PickableObject) -> bool: # REFACTOR -> Código gambiarroso
	var can_insert = false
	
	if "Plate" in object.name:
		
		if not object.is_clean:
			can_insert = .insert_object(object)
	
	return can_insert

func wash_plate() -> bool:
	
	if current_object != null and not current_object.is_clean:
		
		current_object.start_cleaning()
		._start_working(
			current_object.CLEANING_TIME - current_object.cleaning_time_left,
			current_object.CLEANING_TIME,
			current_object.cleaning_time_left
		)
	
	return is_working

func stop_washing() -> void:
	
	if is_working:
		
		_stop_working()
		current_object.stop_cleaning($WorkTimer.time_left)
