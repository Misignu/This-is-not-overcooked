extends "res://objects/areas/pick_places/work_station.gd"

func _ready():
	
	if rotation_degrees >= 90:
		
		$ProgressBar/TextureProgress.fill_mode = TextureProgress.FILL_RIGHT_TO_LEFT

# @signals
func on_cut_finished():
	
	stop_cutting()

# @main
func cut_ingridient() -> bool:
	
	if current_object is Ingredient and current_object.preparation_state == Ingredient.CUTTABLE:
		
		current_object.prepare("cut", $Timer)
		_start_working(
			current_object.CUT_TIME - current_object.preparation_timer_wait_time,
			current_object.CUT_TIME,
			current_object.preparation_timer_wait_time
		)
		is_working = true
	
	return is_working

func stop_cutting() -> void:
	
	if is_working:
		
		_stop_working()
		current_object.stop("cut", $Timer)
