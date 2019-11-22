extends "res://src/objects/areas/pick_places/work_station.gd"

func _on_Timer_timeout():
	stop_cutting()

# @main
func cut_ingridient() -> bool:
	var current_object = pos_current_object.get_child(0)
	
	if current_object is Ingredient and current_object.preparation_state == Ingredient.CUTTABLE:
		
		current_object.prepare("cut", work_timer)
		_start_working(
			current_object.CUT_TIME - current_object.preparation_timer_wait_time,
			current_object.CUT_TIME,
			current_object.preparation_timer_wait_time
		)
	
	return is_working

func stop_cutting() -> void:
	
	if is_working:
		
		pos_current_object.get_child(0).stop(Ingredient.ACTIONS[Ingredient.CUTTABLE], work_timer)
		_stop_working()
