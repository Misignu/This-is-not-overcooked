extends KinematicBody2D
"""
Trata a aplicação de movimento para um corpo de estilo de jogabilidade 'top_down'

@notes
	Para movimenta-lo, você deve chamar o método _move() dentro do método virtual _physics_process(), 
	passando uma direção 'axis' em Vector2
 
	O signal direction_changed é emitido sempre que o corpo altera sua last_direction.
	Captura a direção atual em Vector2.
 
	O signal body_movement_stopped é emitido quando o input direcional for igual a Vector.ZERO (o input direcional é nulo)
"""
signal direction_changed
signal body_movement_stopped

export(float, 0, 1000) var max_speed = 500
export(float, 0, 1000) var acceleration = 100

var motion: Vector2 = Vector2.ZERO
var _last_direction: Vector2 = motion
var _stopped = true

func _move(axis: Vector2) -> void:
	
	if axis == Vector2.ZERO: # Esse é o jeito correto de mover um personagem
		
		apply_friction(acceleration)
		
		if _stopped == false:
			
			emit_signal("body_movement_stopped")
			_stopped = true
		
	else:
		
		if axis != _last_direction:
			
			_last_direction = axis
			emit_signal("direction_changed", axis)
		
		_stopped = false
		
		apply_movement(axis * acceleration)
	
	motion = move_and_slide(motion)

func apply_friction(amount):
	
	if motion.length() > amount:
		
		motion -= motion.normalized() * amount
		
	else:
		
		motion = Vector2.ZERO

func apply_movement(motion_acceleration: Vector2) -> void:
	
	motion += motion_acceleration
#	if motion.length() > max_speed:
#		motion = motion.normalized() * max_speed
	# clever way to the the same as above
	
	motion = motion.clamped(max_speed)
