extends NinePatchRect

export var shake_amplitude: float = 5.0 # distance in pixels
export var shake_lenght: float = 1.0 # duration in secounds

var id: int setget set_id

func _ready():
	
	$MarginContainer/VBoxContainer/ElapsedTime/ProgressBar.max_value = $Timer.wait_time

func _process(_delta):
	
	$MarginContainer/VBoxContainer/ElapsedTime/ProgressBar.value = $Timer.time_left

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

func _on_Timer_timeout():
	
	$AnimationPlayer.play("alert")
	shake()

func _on_Tween_tween_completed(_object, _key):
	
	$AnimationPlayer.play("done")
	Game.coins -= 10

func set_id(value: int):
	id = value