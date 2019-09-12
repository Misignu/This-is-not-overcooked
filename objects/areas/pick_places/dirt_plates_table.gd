extends "res://objects/areas/pick_place.gd"

var plate = preload("res://objects/areas/pickable_objects/plate.tscn")
var plates_counter: int = 0

func _ready():
	
	if "Treadmill" in get_parent().name:
		
		get_parent().set_plates_output(self)

func remove_object() -> PickableObject:
	var dirt_plate: PickableObject
	
	if plates_counter > 0:
		plates_counter -= 1
	
	if plates_counter == 0:
		dirt_plate = .remove_object()
		
	else:
		dirt_plate = plate.instance()
		dirt_plate.position = global_position
		get_parent().get_parent().add_child(dirt_plate)
	
	return dirt_plate
	
#	return 

func insert_object(_object: PickableObject) -> bool:
	return false

func drop_dirt_plate():
	var dirt_plate: PickableObject
	
	if plates_counter == 0:
		
		dirt_plate = plate.instance()
		dirt_plate.position = global_position
		get_parent().get_parent().add_child(dirt_plate)
		dirt_plate.get_node('CollisionShape2D').disabled = true
		current_object = dirt_plate
	
	plates_counter += 1