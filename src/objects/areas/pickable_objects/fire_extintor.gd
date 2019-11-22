extends PickableObject

signal extintor_started
signal extintor_finished

var input_index: int

onready var animation_buffer := $GasRange/AnimationBuffer
onready var gas_particles := $GasRange/Particles2D
onready var gas_player := $GasRange/AnimationPlayer

func _on_GasRange_area_entered(area: Area2D) -> void:
	var fire: Particles2D = area.get_parent()
	
	if "FireParticles" in fire.name:
		
		assert(
			connect("extintor_started", fire, "_on_FireExtintor_extintor_started") == OK and
			connect("extintor_finished", fire, "_on_FireExtintor_extintor_finished") == OK
		)
		
		if fire.is_firing and Input.is_action_pressed(str("player", input_index, "_secoundary_action")):
			fire._on_FireExtintor_extintor_started()

func _on_GasRange_area_exited(area: Area2D) -> void:
	var fire: Particles2D = area.get_parent()
	
	if "FireParticles" in fire.name:
		
		disconnect("extintor_started", fire, "_on_FireExtintor_extintor_started")
		disconnect("extintor_finished", fire, "_on_FireExtintor_extintor_finished")
		fire._on_FireExtintor_extintor_finished()

func _on_AnimationBuffer_timeout() -> void:
	gas_player.stop()

# @override
func grab() -> PickableObject:
	
	get_parent().remove_child(self)
	position = Vector2.ZERO
	return .grab()

# @override
func drop(pos: Vector2) -> void:
	
	stop()
	.drop(pos)

# @main
func start() -> void: # TODO -> Optimize to Collision
	
	gas_particles.emitting = true
	gas_player.play("gas_jet")
	animation_buffer.stop()
	emit_signal("extintor_started")

func stop() -> void:
	
	if is_inside_tree():
		animation_buffer.start()
	
	gas_particles.emitting = false
	emit_signal("extintor_finished")
