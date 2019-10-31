extends "res://objects/areas/pick_places/work_station.gd"

export(String, FILE, "*pan.tscn") var pan_path = ""
var is_fire_danger: bool

onready var alert_player := $FireAlert/AnimationPlayer
onready var texture_rect := $FireAlert/TextureRect

func _ready():
	
	if pan_path != "":
		_add_new_pan(pan_path)

# @signals
func _on_Ingredient_burning_started(firing: bool) -> void:
	
	if firing:
		
		set_is_burning(true)
		
	else:
		alert_player.play("fire_alert")
	
	texture_rect.visible = not firing
	is_fire_danger = not firing

# @main
func insert_object(object: PickableObject) -> bool:
	var can_insert := false
	
	if current_object == null:
		
		if object.is_in_group("pans"):
			can_insert = _insert_pan(object)
		
	elif object is Ingredient:
		
		can_insert = current_object.insert_ingredient(object)
		
		if can_insert:
			
			assert(object.connect("burning_started", self, "_on_Ingredient_burning_started") == OK)
			_start_cooking()
	
	return can_insert

func remove_object() -> PickableObject:
	
	if is_working:
		_stop_working()
	
	if current_object != null:
		
		if current_object.is_buffering:
			current_object.stop_buffering()
		
		if current_object.current_ingredient != null:
			
			if is_fire_danger:
				
				alert_player.stop()
				texture_rect.visible = false
				current_object.stop_burning()
			
			current_object.current_ingredient.disconnect("burning_started", self, "_on_Ingredient_burning_started")
		
		work_timer.disconnect("timeout", current_object, "start_buffering")
	
	return .remove_object()


func _add_new_pan(value: String):
	var new_pan: PickableObject = load(value).instance()
	
	get_parent().call_deferred("add_child", new_pan)
	assert(_insert_pan(new_pan))
	new_pan.position = position

func _insert_pan(pan: PickableObject) -> bool:
	var can_insert = .insert_object(pan)
	
	assert(work_timer.connect("timeout", pan, "start_buffering") == OK)
	
	if can_insert and pan.current_ingredient != null:
		
		assert(pan.current_ingredient.connect("burning_started", self, "_on_Ingredient_burning_started") == OK)
		
		if pan.current_ingredient.preparation_state == 0:
			pan.start_buffering()
			
		else:
			_start_cooking()
	
	return can_insert


func _start_cooking():
	
	if current_object.prepare_ingridient(work_timer):
		
		_start_working(
			current_object.current_ingredient.fry_time - current_object.current_ingredient.preparation_timer_wait_time,
			current_object.current_ingredient.fry_time,
			current_object.current_ingredient.preparation_timer_wait_time
		)

func _stop_working() -> void:
	
	current_object.prepare_stop(work_timer)
	._stop_working()
