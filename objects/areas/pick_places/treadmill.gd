extends "res://objects/areas/pick_place.gd"

export(int, 0, 60) var return_time = 3
var plates_output: Area2D setget set_plates_output

func _on_Tween_tween_completed(object, _key):
	var new_timer = Timer.new()
	
	Game.coins += object.current_recipe.price
	remove_object().queue_free()
	add_child(new_timer)
	new_timer.connect("timeout", self, "_on_Timer_timeout", [new_timer])
	new_timer.start(return_time)

func _on_Timer_timeout(timer: Timer):
	print("The timer timeout: ", timer)
	if plates_output != null:
		
		plates_output.drop_dirt_plate()
		timer.queue_free()
		
	else:
		
		push_error("None DirtPlatesTable atached to the Treadmill")

# @main
func insert_object(object: PickableObject) -> bool: # TODO REFACTOR -> Código gambiarroso
	var can_insert = false
	print("Try insert ", object, " in treadmill")
	
	if "Plate" in object.name:
		
		if object.current_recipe != null:
			
			if object.current_recipe.frame == 3:
				
				can_insert = .insert_object(object)
				$Tween.interpolate_property(object, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				$AudioStreamPlayer.play()
				$Tween.start()
	
	return can_insert

# @setters
func set_plates_output(area: Area2D) -> void:
	plates_output = area
