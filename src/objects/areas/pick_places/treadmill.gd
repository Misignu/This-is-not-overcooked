extends "res://src/objects/areas/pick_place.gd"

signal recipe_delived
signal plate_returned

export(float, 60) var return_time: float = 10
const BUFFER_REPLACEMENT_TIME = 5
var cached_plates := Array()

onready var tween := $Tween
onready var deliver_sine_sfx := $DeliverSineSFX

func _on_Tween_tween_completed(object, key: String) -> void:
	
	if object is PickableObject and key == "modulate":
		
		_buffer_replacement(.remove_object())
#		plate.current_recipe = null # WATCH -> Verificar a necessidade dessa linha
		cached_plates.append(object)
		_create_and_run_timer()

func _on_plate_return_Timer_timeout(timer: Timer) -> void:
	
	emit_signal("plate_returned", cached_plates.back())
	cached_plates.pop_back()
	timer.disconnect("timeout", self, "_on_plate_return_Timer_timeout")
	timer.queue_free()


# @override
func insert_object(object: PickableObject) -> bool: # REFACTOR -> Código gambiarroso
	var can_insert = false
	
	if "Plate" in object.name:
		
		if object.current_recipe != null and object.is_clean:
			can_insert = .insert_object(object)
	
	if can_insert:
		_delivery_animation(object)
	
	return can_insert

# @main
func _delivery_animation(plate: PickableObject):
	
	tween.interpolate_property(plate, "modulate", plate.modulate, Color.transparent, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT) # WATCH -> Verificar a possibilidade de interpolar somente o alpha
	deliver_sine_sfx.play()
	tween.start()
	emit_signal("recipe_delived", plate.current_recipe)

func _buffer_replacement(object: PickableObject) -> void:
	var buffer: = Timer.new()
	
	buffer.connect("timeout", self, "_on_buffer_timeout", [object, buffer])
	add_child(buffer)
	buffer.start(BUFFER_REPLACEMENT_TIME)

func _create_and_run_timer():
	var timer := Timer.new()
	
	add_child(timer)
	assert(timer.connect("timeout", self, "_on_plate_return_Timer_timeout", [timer]) == OK)
	timer.start(return_time)
