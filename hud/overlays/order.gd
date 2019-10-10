extends NinePatchRect

export var shake_amplitude: float = 5.0 # distance in pixels
export var shake_lenght: float = 1.0 # duration in secounds

var stack_id: int setget set_stack_id
onready var progress_bar := $MarginContainer/VBoxContainer/ElapsedTime/ProgressBar

func _ready():
	
	progress_bar.max_value = $LimitTimer.wait_time

func _process(_delta):
	
	progress_bar.value = $LimitTimer.time_left

# @signals
func _on_Tween_tween_completed(_object, _key):
	
	$AnimationPlayer.play("done")
	Game.coins -= 10

func _on_Timer_timeout():
	
	$AnimationPlayer.play("alert")
	shake()

# @main
func complete():
	
	$AnimationPlayer.play("done")

func shake() -> void:
	
	$Tween.interpolate_method(self, "move", Vector2(shake_amplitude, -shake_amplitude), rect_position, shake_lenght, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	assert($Tween.start())

func move(target_position):
	var rand := Vector2()
	
	rand.x = rand_range(-target_position.x, target_position.x)
	rand.y = rand_range(-target_position.y, target_position.y)
	rect_position = rand

func set_stack_id(value: int):
	stack_id = value

