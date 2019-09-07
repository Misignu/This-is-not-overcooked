extends "res://objects/top_down_body.gd"
"""
Script que recebe inputs que movimentam o personagem e o permitem interagir com outros objetos da cena.
"""

export(int, 1, 4) var controller_index = 1 # Um setget pode ser usado para alterar o controle in-game após o objeto ter sido instanciado

var interacting: bool = false
var current_object: PickableObject = null setget set_current_object

onready var up: String = str("player", controller_index, "_move_up")
onready var down: String = str("player", controller_index, "_move_down")
onready var left: String = str("player", controller_index, "_move_left")
onready var right: String = str("player", controller_index, "_move_right")
onready var primary_action: String = str("player", controller_index, "_primary_action")
onready var secoundary_action: String = str("player", controller_index, "_secoundary_action")

func _physics_process(_delta) -> void:
	
	if not interacting:
		var axis = _get_input_axis()
		
		_move(axis)
		_walk_animation_play(axis)
#
#	else:
#
#		apply_friction(acceleration)
	if $RayCast2D.is_colliding():
		_interact($RayCast2D.get_collider()) # WATCH
		
	elif Input.is_action_just_pressed(primary_action) and current_object != null:
		
		current_object.drop(global_position + (_last_direction * 10))
		set_current_object(null)

# @signals
func _on_Player_direction_changed(direction: Vector2):
	
	match direction:
		
		Vector2.UP:
			$PickableObjectSprite.visible = false
			$RayCast2D.cast_to = Vector2(0, -18)
			continue
		
		Vector2.DOWN:
			$PickableObjectSprite.position = Vector2(0, 2)
			$RayCast2D.cast_to = Vector2(0, 18)
			$Sprite/Expressions.frame = 0
			continue
		
		Vector2.LEFT:
			$PickableObjectSprite.position = Vector2(-8, 0)
			$RayCast2D.cast_to = Vector2(-16, 0)
			continue
		
		Vector2.RIGHT:
			$PickableObjectSprite.position = Vector2(8, 0)
			$RayCast2D.cast_to = Vector2(16, 0)
			continue
		
		Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT:
			$PickableObjectSprite.visible = true
			continue
		
		_:
			$Sprite/Expressions.visible = false

func _on_Player_body_movement_stopped() -> void:
	$AnimationPlayer.play("idle")
	
	match _last_direction:
		
		Vector2.UP:
			$Sprite.frame = 10
		
		Vector2.DOWN:
			$Sprite.frame = 1
			$Sprite/Expressions.visible = true
		
		Vector2.LEFT:
			$Sprite.frame = 4
		
		Vector2.RIGHT:
			$Sprite.frame = 7

# @main
func _get_input_axis() -> Vector2:
	var axis = Vector2.ZERO
	
#	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left")) # Clever way pra conver os inputs do jogador no movimento do personagem
#	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up")) # Clever way pra conver os inputs do jogador no movimento do personagem
	# Cleveriest way pra receber os inputs
	axis.x = Input.get_action_strength(right) - Input.get_action_strength(left) # immediately gets a float value to vector component without conversions
	axis.y = Input.get_action_strength(down) - Input.get_action_strength(up) # immediately gets a float value to vector component without conversions
	
	return axis.normalized()

func _walk_animation_play(direction):
	
	match direction:
		
		Vector2.UP:
			$AnimationPlayer.play("walk_up")
		
		Vector2.DOWN:
			$AnimationPlayer.play("walk_down")
		
		Vector2.LEFT:
			$AnimationPlayer.play("walk_left")
		
		Vector2.RIGHT:
			$AnimationPlayer.play("walk_right")

func _interact(area: Area2D) -> void:
	
	if current_object == null:
		
		if Input.is_action_just_pressed(primary_action):
			_grab(area) # WATCH
		
		if Input.is_action_just_pressed(secoundary_action):
			_fire_action(area) # WATCH
		
		if Input.is_action_just_released(secoundary_action):
			_stop_action(area)
		
	else:
		
		if Input.is_action_just_pressed(primary_action):
			_drop(area) # WATCH
	
	$Zom/Label.text = current_object.name if current_object != null else ""

func _grab(area: Area2D) -> void:
	
	if area.has_method("remove_object"):
		
		set_current_object(area.remove_object()) # WATCH
		
	elif area.has_method("grab"):
		
		set_current_object(area.grab())

func _drop(area: Area2D) -> void:
	print(area.name)
	
	if area.has_method("insert_object"):
		
		if area.insert_object(current_object): # WATCH
			
			
			set_current_object(null)
		
#	elif area.has_method("insert_ingredient") and current_object is Ingredient:
#
#		if area.insert_ingredient(current_object):
#
#			set_current_object(null)

func _fire_action(area: Area2D):
	print('action fired')
	
	if area.has_method("cut_ingridient"):
		
		if area.cut_ingridient(): # WATCH
			
			interacting = true

func _stop_action(target):
	
	if target.has_method("stop_cutting"):
		
		target.stop_cutting()
	
	interacting = false

#func _fire_action(area: Area2D) -> void:
#
#	if area.has_method("cut_ingridient") and not area.is_playing:
#
#		interacting = target.cut_ingridient()

# @setters
func set_current_object(object: PickableObject) -> void:
	
	if object == null:
		
		$PickableObjectSprite.texture = null
		
	else:
		
		object.visible = false
		$PickableObjectSprite.texture = object.get_node('Sprite').texture
	
	current_object = object
