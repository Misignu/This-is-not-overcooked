extends "res://objects/areas/pick_place.gd"

var is_working: bool = false

onready var texture_progress := $ProgressBar/TextureProgress
onready var bar_tween := $ProgressBar/Tween
onready var work_timer := $WorkTimer

func _ready():
	
	if rotation_degrees >= 90:
		
		texture_progress.fill_mode = TextureProgress.FILL_RIGHT_TO_LEFT

# @main
func _start_working(initial_time: float, final_time: float, duration: float) -> void:
	
	texture_progress.max_value = final_time
	bar_tween.interpolate_property(texture_progress, "value", initial_time, final_time, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	bar_tween.start()
	texture_progress.visible = true
	work_timer.start(duration)
	is_working = true

func _stop_working():
	
	bar_tween.stop(texture_progress, "value")
	texture_progress.visible = false
	work_timer.stop()
	is_working = false
