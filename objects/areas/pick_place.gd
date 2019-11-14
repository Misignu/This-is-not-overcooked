tool
extends Area2D

const BANISH_FIRE_TIME = 3

var current_object: PickableObject = null
var is_burning: bool setget set_is_burning
var fire_intensity: float = 1.0

onready var fire_tween := $FireTween
onready var fire_particles := $FireParticles
onready var fire_max_scale: float = fire_particles.process_material.scale
onready var scan := $Scan
onready var fire_timer := $FireTimer
onready var fire_bsfx := $FireBSFX2D

func _ready() -> void:
	fire_particles.process_material = fire_particles.process_material.duplicate(true) # REFACTOR -> Optimazation

# @signals
func _on_FireExtintor_extintor_started(): # REFACTOR -> Optimization
	var duration: float = BANISH_FIRE_TIME * fire_intensity
	
	fire_tween.stop(fire_particles, "process_material:scale")
	fire_tween.interpolate_property(self, "fire_intensity", fire_intensity, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	fire_tween.interpolate_property(fire_particles, "process_material:scale", fire_particles.process_material.scale, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	fire_tween.start()

func _on_FireExtintor_extintor_finished(): # REFACTOR -> Optimization
	var duration: float = BANISH_FIRE_TIME * (1.0 - fire_intensity)
	
	fire_tween.stop(self, "fire_intensity")
	fire_tween.stop(fire_particles, "process_material:scale")
	fire_tween.interpolate_property(self, "fire_intensity", fire_intensity, 1.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	fire_tween.interpolate_property(fire_particles, "process_material:scale", fire_particles.process_material.scale, fire_max_scale, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func _on_FireTimer_timeout():
	
	scan.set_physics_process(true)
	scan.enabled = true

func _on_FireTween_tween_completed(object, key):
	
	if object == self and key == ":fire_intensity" and fire_intensity == 0:
		
		set_is_burning(false)

# @main
func insert_object(object: PickableObject) -> bool:
	var can_insert: bool = false
	
	if current_object == null:
		
		object.visible = true
		current_object = object
		current_object.get_node('CollisionShape2D').disabled = true
		current_object.global_position = global_position
		can_insert = true
		
	elif object is Ingredient and current_object.has_method("insert_ingredient"):
		
		can_insert = current_object.insert_ingredient(object)
	
	return can_insert

func remove_object() -> PickableObject:
	var object = current_object
	
	if current_object != null:
		object.visible = false
	
	current_object = null
	
	return object

# @setters
func set_is_burning(value := true):
	
	if value:
		
		fire_timer.start()
		fire_bsfx.play()
		
	else:
		fire_bsfx.stop()
	
	fire_particles.emitting = value
	is_burning = value
