extends PickableObject

signal extintor_started
signal extintor_finished

onready var origin = get_parent() setget, get_origin
var input_index: int

onready var animation_buffer := $GasRange/AnimationBuffer
onready var gas_particles := $GasRange/Particles2D
onready var gas_player := $GasRange/AnimationPlayer

func _on_GasRange_area_entered(area: Area2D) -> void:
#	print("Area entered: ", area.name)
	
	assert(
		connect("extintor_started", area, "_on_FireExtintor_extintor_started") == OK and
		connect("extintor_finished", area, "_on_FireExtintor_extintor_finished") == OK
	)
	
	if area.is_burning and Input.is_action_pressed(str("player", input_index, "_secoundary_action")):
		area._on_FireExtintor_extintor_started()

func _on_GasRange_area_exited(area: Area2D) -> void:
#	print("Area exited: ", area.name)
	
	disconnect("extintor_started", area, "_on_FireExtintor_extintor_started")
	disconnect("extintor_finished", area, "_on_FireExtintor_extintor_finished")
	area._on_FireExtintor_extintor_finished()

func _on_AnimationBuffer_timeout() -> void:
	gas_player.stop()

# @override
func grab() -> PickableObject:
	
	get_parent().remove_child(self)
	position = Vector2.ZERO
	return .grab()

# @main
func start() -> void: # TODO -> Optimize to Collision
	
	gas_particles.emitting = true
	gas_player.play("gas_jet")
	animation_buffer.stop()
	emit_signal("extintor_started")

func stop() -> void:
	
	gas_particles.emitting = false
	animation_buffer.start()
	emit_signal("extintor_finished")

# @getters
func get_origin() -> Node:
	return origin
