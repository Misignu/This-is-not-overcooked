extends "res://objects/bodies/top_down_body.gd"
"""
Script que recebe inputs que movimentam o personagem e o permitem interagir com outros objetos da cena.

# TODO REFACTOR -> Substituir o modo de verificação de objeto por nomes por tipo duck_type ou groups
"""

export(int, 1, 4) var controller_index = 1 # Um setget pode ser usado para alterar o controle in-game após o objeto ter sido instanciado

var is_interacting := false
var current_object: PickableObject = null setget set_current_object

onready var up: String = str("player", controller_index, "_move_up")
onready var down: String = str("player", controller_index, "_move_down")
onready var left: String = str("player", controller_index, "_move_left")
onready var right: String = str("player", controller_index, "_move_right")
onready var primary_action: String = str("player", controller_index, "_primary_action")
onready var secoundary_action: String = str("player", controller_index, "_secoundary_action")

func _physics_process(_delta) -> void:
	
	var axis = _get_input_axis()
	
	if not is_interacting:
		
		_move(axis)
		_walk_animation_play(axis)
	
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
		
		if Input.is_action_just_pressed(secoundary_action) and not is_interacting:
			_fire_action(area) # WATCH
		
		if Input.is_action_just_released(secoundary_action) and is_interacting:
			_stop_action(area)
		
	else:
		
		if Input.is_action_just_pressed(primary_action):
			_drop(area) # WATCH

func _grab(area: Area2D) -> void:
	
	if area.has_method("remove_object"):
		
		set_current_object(area.remove_object()) # WATCH
		
	elif area.has_method("grab"):
		
		set_current_object(area.grab())

func _drop(area: Area2D) -> void:
	
	if ("Pan" in current_object.name) and ("PickPlace" in area.name) and (area.current_object != null) and ("Plate" in area.current_object.name): # TODO REFACTOR -> Código gambiarroso
		
		current_object.transfer_ingredient(area)
		
	elif area.has_method("insert_object"):
		
		if area.insert_object(current_object): # WATCH
			set_current_object(null)
		
	elif area.has_method("insert_ingredient") and current_object is Ingredient:
		
		if area.insert_ingredient(current_object):
			set_current_object(null)

func _fire_action(area: Area2D):
	
	if area.has_method("cut_ingridient"):
		
		if area.cut_ingridient(): # WATCH
			is_interacting = true
	
	if area.has_method("wash_plate"):
		
		area.wash_plate()
		is_interacting = true
	
	if is_interacting:
		assert(area.get_node("Timer").connect("timeout", self, "_stop_interaction", [area.get_node("Timer")]) == OK)

func _stop_action(area: Area2D):
	
	if area.has_method("stop_cutting"):
		area.stop_cutting()
	
	if area.has_method("stop_washing"):
		area.stop_washing()
	
	_stop_interaction(area.get_node("Timer"))

func _stop_interaction(timer: Timer):
	
	is_interacting = false
	timer.disconnect("timeout", self, "_stop_interaction")

# @setters
func set_current_object(object: PickableObject) -> void:
	
	if object == null:
		
		$PickableObjectSprite.texture = null
		
	else:
		
		object.visible = false
		$PickableObjectSprite.texture = object.get_node('Sprite').texture
		object.get_node("CollisionShape2D").disabled = true
	
	current_object = object
