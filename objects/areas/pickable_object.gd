extends Area2D
class_name PickableObject

export var use_pick_place: bool = false

func _ready():
	
	if use_pick_place:
		var pick_place = load("res://objects/areas/pick_place.tscn").instance()
		
		pick_place.position = position
		pick_place.current_object = self
		$CollisionShape2D.disabled = true
		get_parent().call_deferred("add_child", pick_place)

func grab() -> PickableObject:
	
	$CollisionShape2D.disabled = true
	return self

func drop(pos) -> void:
	
	visible = true
	$CollisionShape2D.disabled = false
	position = pos - (get_parent().global_position)
