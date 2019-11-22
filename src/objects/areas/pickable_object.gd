extends Area2D
class_name PickableObject

const PICK_PLACE_PATH = "res://src/objects/areas/pick_place.tscn"
export var use_pick_place: bool = false

onready var origin := get_parent() setget, get_origin

func _ready():
	
	if use_pick_place:
		_add_pick_place()

func grab() -> PickableObject:
	
	if is_inside_tree():
		get_parent().remove_child(self)
	
	position = Vector2.ZERO
	$CollisionShape2D.disabled = true
	
	return self

func drop(pos: Vector2) -> void:
	
	origin.add_child(self)
	global_position = pos
	$CollisionShape2D.disabled = false

func _add_pick_place() -> void:
	
	var pick_place: Area2D = load(PICK_PLACE_PATH).instance() 
	
	pick_place.position = position
	get_parent().call_deferred("remove_child", self)
	origin.call_deferred("add_child", pick_place)
	pick_place.call_deferred("insert_object", self)

# @getters
func get_origin() -> Node:
	return origin
