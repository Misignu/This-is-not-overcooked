extends PickableObject

signal extintor_started
signal extintor_finished

onready var origin = get_parent() setget, get_origin

func _on_GasRange_area_entered(area: Area2D) -> void:
	print("Area entered: ", area.name)
	
	assert(
		connect("extintor_started", area, "_on_FireExtintor_extintor_started") == OK and
		connect("extintor_finished", area, "_on_FireExtintor_extintor_finished") == OK
	)

func _on_GasRange_area_exited(area: Area2D) -> void:
	print("Area exited: ", area.name)
	
	disconnect("extintor_started", area, "_on_FireExtintor_extintor_started")
	disconnect("extintor_finished", area, "_on_FireExtintor_extintor_finished")

func _on_AnimationBuffer_timeout() -> void:
	$GasRange/AnimationPlayer.stop()

# @override
func grab() -> PickableObject:
	
	get_parent().remove_child(self)
	position = Vector2.ZERO
	return .grab()

# @main
func start() -> void: # TODO -> Optimize to Collision
	
	$GasRange/Particles2D.emitting = true
	$GasRange/AnimationPlayer.play("gas_jet")
	$GasRange/AnimationBuffer.stop()
	emit_signal("extintor_started")

func stop() -> void:
	
	$GasRange/Particles2D.emitting = false
	$GasRange/AnimationBuffer.start()
	emit_signal("extintor_finished")

# @getters
func get_origin() -> Node:
	return origin
