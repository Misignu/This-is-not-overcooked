extends "res://objects/areas/pick_places/work_station.gd"

const BURN_BUFFER_TIME = 3

export(String, FILE, "*pan.tscn") var pan = ""
var is_buffering := false
var is_burning := false

func _ready():
	
	if rotation_degrees >= 90:
		
		$ProgressBar/TextureProgress.fill_mode = TextureProgress.FILL_RIGHT_TO_LEFT
	
	if pan != "":
		
		_add_new_pan(pan)

# @signals
func _on_fry_finished() -> void:
	
	_stop()

func _on_burn_buffer_Timer_finished():
	
	$Timer.disconnect("timeout", self, "_on_burn_buffer_Timer_finished")
	assert(current_object.current_ingredient.get_node("BurnTimer").connect("timeout", self, "_on_ingredient_burned") == OK)
	current_object.burn_ingredient()
	$ProgressBar/AnimationPlayer.play("fire_alert")
	$ProgressBar/TextureRect.visible = true

func _on_ingredient_burned() -> void:
	
	$ProgressBar/AnimationPlayer.stop()
	$ProgressBar/TextureRect.visible = false

# @main
func insert_object(object: PickableObject) -> bool:
	var can_insert: bool = false
	
	if current_object == null:
		
		if object.is_in_group("pans"):
			
			can_insert = .insert_object(object)
		
	elif object is Ingredient:
		
		can_insert = current_object.insert_ingredient(object)
		object.visible = false
	
	if can_insert:
		
		_start_cooking()
#		_fry_ingridient(current_object.current_ingredient)
	
	return can_insert

func remove_object() -> PickableObject:
	
	if is_working:
		_stop()
	
	if is_buffering:
		_stop_buffering()
	
	if is_burning:
		_stop_burning()
	
	return .remove_object()

#func _add_new_pan(value: String = pan) -> void:

func _add_new_pan(value):
	var new_pan = load(value).instance()
	
	new_pan.position = position
	current_object = new_pan
	new_pan.get_node("CollisionShape2D").disabled = true
	get_parent().call_deferred("add_child", new_pan)
	update()

func _start_cooking():
	
	if current_object.fry_ingridient($Timer):
		
		_start_working(
			current_object.current_ingredient.fry_time - current_object.current_ingredient.preparation_timer_wait_time,
			current_object.current_ingredient.fry_time,
			current_object.current_ingredient.preparation_timer_wait_time
		)

func _stop() -> void:
	
	current_object.stop($Timer)
	_stop_working()
	
	assert($Timer.connect("timeout", self, "_on_burn_buffer_Timer_finished") == OK)
	$Timer.start(BURN_BUFFER_TIME)

func _stop_buffering() -> void:
	
	$Timer.stop()
	$Timer.disconnect("timeout", self, "_on_burn_buffer_Timer_finished")

func _stop_burning() -> void:
	
	current_object.stop_burning()
	current_object.current_ingredient.get_node("BurnTimer").disconnect("timeout", self, "_on_ingredient_burned")
