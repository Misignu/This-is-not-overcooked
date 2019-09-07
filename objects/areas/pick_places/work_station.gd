extends "res://objects/areas/pick_place.gd"

var is_working: bool = false

func _on_work_finished():
	
	_stop_working()

# @main
func _start_working(initial_time: float, final_time: float, duration: float) -> void:
	
	$ProgressBar/TextureProgress.max_value = final_time
	$ProgressBar/Tween.interpolate_property($ProgressBar/TextureProgress, "value", initial_time, final_time, duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	$ProgressBar/Tween.start()
	assert($Timer.connect("timeout", self, "_on_work_finished") == OK)
	$ProgressBar/TextureProgress.visible = true
	is_working = true

func _stop_working():
	
	$ProgressBar/Tween.stop($ProgressBar/TextureProgress, "value")
	$Timer.disconnect("timeout", self, "_on_work_finished")
	$ProgressBar/TextureProgress.visible = false
	is_working = false
