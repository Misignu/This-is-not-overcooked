extends "res://objects/areas/pick_places/work_station.gd"

func _on_Timer_timeout():
	stop_cutting()

# @main
func cut_ingridient() -> bool:
	
	if current_object is Ingredient and current_object.preparation_state == Ingredient.CUTTABLE:
		
		current_object.prepare("cut", $WorkTimer)
		_start_working(
			current_object.CUT_TIME - current_object.preparation_timer_wait_time,
			current_object.CUT_TIME,
			current_object.preparation_timer_wait_time
		)
	
	return is_working

func stop_cutting() -> void:
	
	if is_working:
		
		current_object.stop(Ingredient.ACTIONS[Ingredient.CUTTABLE], $WorkTimer)
		_stop_working()
