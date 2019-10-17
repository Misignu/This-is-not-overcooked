extends "res://objects/areas/pick_place.gd"

var is_working: bool = false

func _ready():
	
	if rotation_degrees >= 90:
		
		$ProgressBar/TextureProgress.fill_mode = TextureProgress.FILL_RIGHT_TO_LEFT

# @main
func _start_working(initial_time: float, final_time: float, duration: float) -> void:
	
	$ProgressBar/TextureProgress.max_value = final_time
	$ProgressBar/Tween.interpolate_property($ProgressBar/TextureProgress, "value", initial_time, final_time, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$ProgressBar/Tween.start()
	$ProgressBar/TextureProgress.visible = true
	$WorkTimer.start(duration)
	is_working = true

func _stop_working():
	
	$ProgressBar/Tween.stop($ProgressBar/TextureProgress, "value")
	$ProgressBar/TextureProgress.visible = false
	$WorkTimer.stop()
	is_working = false
