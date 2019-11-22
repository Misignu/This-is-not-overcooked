extends "res://src/objects/areas/pick_places/work_station.gd"
"""
Stove é uma WorkStation que permite preparar ingredientes de uma pan.

# WATCH -> Refazendo código
"""
const ANIMATIONS = {
	alert = "fire_alert"
}

export(String, FILE, "*pan.tscn") var pan_path = ""
var is_fire_danger: bool setget set_is_fire_danger

onready var alert_player := $FireAlert/AnimationPlayer
onready var texture_rect := $FireAlert/TextureRect

func _ready() -> void:
	var new_pan = load(pan_path).instance().grab()
	
	if pan_path != "":
		
		new_pan.origin = get_parent().get_parent()
		assert(insert_object(new_pan))

# @signals
func _on_Ingredient_burning_started(is_firing: bool) -> void:
	
	if is_firing:
		set_is_burning(true)
		
	else:
		alert_player.play(ANIMATIONS.alert)
	
	texture_rect.visible = not is_firing
	is_fire_danger = not is_firing

# @main
func insert_object(object: PickableObject) -> bool:
	var inserted: bool
	
	if pos_current_object.get_child_count() == 0:
		
		if object.is_in_group("pans"):
			inserted = _insert_pan(object)
		
	elif object is Ingredient:
		
		if pos_current_object.get_child(0).insert_ingredient(object):
			
			assert(object.connect("burning_started", self, "_on_Ingredient_burning_started") == OK)
			_start_cooking()
			inserted = true
	
	return inserted

func remove_object() -> PickableObject:
	
	var object: PickableObject
	var current_object: PickableObject
	
	if not is_burning and pos_current_object.get_child_count() > 0:
		
		current_object = pos_current_object.get_child(0)
		
		if is_working:
			_stop_working()
		
		if is_fire_danger:
			set_is_fire_danger(false)
		
		if current_object.has_method("get_recipe"):
			_copple(current_object, false)
		
		object = current_object.grab()
	
	return object

func _insert_pan(pan: PickableObject) -> bool:
	var can_insert = .insert_object(pan)
	
	_copple(pan)
	
	if pan.get_recipe() != null:
		
		if pan.get_recipe().preparation_state <= 0:
			pan.start_buffering()
			
		else:
			_start_cooking()
	
	return can_insert

func _copple(object: PickableObject, to_connect: bool = true) -> void:
	var recipe: Node = object.get_recipe()
	
	if to_connect:
		assert(work_timer.connect("timeout", object, "start_buffering") == OK)
		
	else:
		work_timer.disconnect("timeout", object, "start_buffering")
	
	if recipe != null:
		
		if to_connect:
			assert(recipe.connect("burning_started", self, "_on_Ingredient_burning_started") == OK)
			
		else:
			recipe.disconnect("burning_started", self, "_on_Ingredient_burning_started")


func _start_cooking() -> void:
	var current_object = pos_current_object.get_child(0)
	
	if current_object.prepare_ingridient(work_timer):
		
		_start_working( # WATCH
			current_object.get_recipe().fry_time - current_object.get_recipe().preparation_timer_wait_time,
			current_object.get_recipe().fry_time,
			current_object.get_recipe().preparation_timer_wait_time
		)

func _stop_working() -> void:
	
	pos_current_object.get_child(0).prepare_stop(work_timer)
	._stop_working()

func set_is_fire_danger(value: bool) -> void:
	
	if not value:
		
		alert_player.stop()
		texture_rect.visible = false # TODO -> Tween it! :D
		pos_current_object.get_child(0).stop_burning()
	
	is_fire_danger = value
