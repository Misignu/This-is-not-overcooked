extends "res://src/objects/bodies/top_down_body.gd"
"""
Corpo top_down que recebe inputs para movimentar-se e interagir com outros objetos.

@notes
	# REFACTOR -> Substituir o modo de verificação de objeto por nomes por tipo duck_type ou groups
	
	shift_visibility:
	-> Altera a visibilidade de player, desativando suas colisões
	
	_move()
	-> Movimenta o corpo e altera a animação.
	
	_get_input_axis()
	-> Captura um input e retorna uma direção de movimento.
	
	_interact()
	-> Captura um input e tenta alguma interação com o colisor.
	
	_try_drop()
	-> Verifica se área colisora pode receber um objeto, se ela não existir o objeto será despejado na posição mais próxima
	
	_walk_animation_play()
	-> Altera a animação conforme a direção passada.
	
	_grab()
	-> Adiciona um objeto do colisor, ou o próprio colisor como o current_object.
	
	_grab_active()
	-> Adiciona um objeto do colisor, ou o próprio colisor como o current_active.
	
	_drop_active()
	-> Despeja o current_active na área/ posição mais próxima.
	
	_drop()
	-> Despeja o current_object na área/ posição mais próxima.
	
	_fire_action()
	-> Inicia uma interação com o colisor.
	
	_stop_action()
	-> Interrompe uma interação com o colisor.
"""

export(int, -1, 4) var controller_index = 1 setget set_controller_index # Um setget pode ser usado para alterar o controle in-game após o objeto ter sido instanciado

var is_interacting := false

var up: String
var down: String
var left: String
var right: String
var primary_action: String
var secoundary_action: String

export var frame_up: int = 10
export var frame_down: int = 1
export var frame_left: int = 4
export var frame_right: int = 7

onready var sprite := $Sprite
onready var ray_cast := $RayCast2D
onready var pos_grabbed_object := $GrabbedObject
onready var expressions := $Sprite/Expressions
onready var animation_player := $AnimationPlayer

func _physics_process(_delta) -> void:
	
	if not is_interacting:
		_move(_get_input_axis())
	
	if ray_cast.is_colliding():
		_interact(ray_cast.get_collider())
		
	elif Input.is_action_just_pressed(primary_action) and pos_grabbed_object.get_child_count() > 0:
		_drop_object()
	
	if pos_grabbed_object.get_child_count() == 1:
		
		if "FireExtintor" in pos_grabbed_object.get_child(0).name:
			
			if Input.is_action_just_pressed(secoundary_action):
				pos_grabbed_object.get_child(0).start() # WATCH
				
			elif Input.is_action_just_released(secoundary_action):
				pos_grabbed_object.get_child(0).stop() # WATCH

# @signals
func _on_Player_direction_changed(direction: Vector2) -> void:
	
	match direction:
		
		Vector2.UP:
			
			ray_cast.cast_to = Vector2(0, -18)
			pos_grabbed_object.z_index = -1
			pos_grabbed_object.show_behind_parent = true
			pos_grabbed_object.rotation_degrees = 0
			continue
		
		Vector2.DOWN:
			
			ray_cast.cast_to = Vector2(0, 18)
			expressions.frame = 0
			pos_grabbed_object.rotation_degrees = 180
			continue
		
		Vector2.LEFT:
			
			ray_cast.cast_to = Vector2(-16, 0)
			pos_grabbed_object.rotation_degrees = -90
			continue
		
		Vector2.RIGHT:
			
			ray_cast.cast_to = Vector2(16, 0)
			pos_grabbed_object.rotation_degrees = 90
			continue
		
		Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT:
			
			pos_grabbed_object.z_index = 0
			pos_grabbed_object.show_behind_parent = false
			continue
		
		_:
			expressions.visible = false
	
	pos_grabbed_object.position = direction * 10 # WATCH -> Testando nova feature

func _on_Player_body_movement_stopped() -> void:
	animation_player.play("idle")
	
	match _last_direction:
		
		Vector2.UP:
			sprite.frame = frame_up
		
		Vector2.DOWN:
			sprite.frame = frame_down
			expressions.visible = true
		
		Vector2.LEFT:
			sprite.frame = frame_left
		
		Vector2.RIGHT:
			sprite.frame = frame_right

# @override
func shift_visibility(show := true) -> void:
	
	visible = show
	$CollisionShape2D.disabled = not show
	set_process_input(show)

func _move(axis: Vector2) -> void:
	
	._move(axis)
	_walk_animation_play(axis)

# @main
func _get_input_axis() -> Vector2:
	var axis = Vector2.ZERO
	
#	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left")) # Clever way pra conver os inputs do jogador no movimento do personagem
#	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up")) # Clever way pra conver os inputs do jogador no movimento do personagem
	# Cleveriest way pra receber os inputs
	axis.x = Input.get_action_strength(right) - Input.get_action_strength(left) # immediately gets a float value to vector component without conversions
	axis.y = Input.get_action_strength(down) - Input.get_action_strength(up) # immediately gets a float value to vector component without conversions
	
	return axis.normalized()

func _walk_animation_play(direction: Vector2) -> void:
	
	match direction:
		
		Vector2.UP:
			animation_player.play("walk_up")
		
		Vector2.DOWN:
			animation_player.play("walk_down")
		
		Vector2.LEFT:
			animation_player.play("walk_left")
		
		Vector2.RIGHT:
			animation_player.play("walk_right")


func _interact(area: Area2D) -> void:
	
	if pos_grabbed_object.get_child_count() == 0:
		
		if Input.is_action_just_pressed(primary_action):
			_grab_object(area)
		
		if Input.is_action_just_pressed(secoundary_action) and not is_interacting:
			_fire_action(area)
		
		if Input.is_action_just_released(secoundary_action) and is_interacting:
			_stop_action(area)
		
	else:
		
		if Input.is_action_just_pressed(primary_action):
			_insert_object(area)

func _grab_object(area: Area2D) -> void:
	var object: PickableObject
	
	if area.has_method("remove_object"):
		object = area.remove_object()
		
	elif area.has_method("grab"):
		object = area.grab()
	
	if object != null:
		
		if "FireExtintor" in object.name:
			object.input_index = controller_index
		
		pos_grabbed_object.add_child(object)

func _insert_object(area: Area2D) -> void:
	
	var object: PickableObject = pos_grabbed_object.get_child(0)
	
	if object is Ingredient and area.has_method("insert_ingredient"):
		
		object.origin = get_parent().get_parent()
		pos_grabbed_object.remove_child(object)
		
		if not area.call("insert_ingredient", object):
			pos_grabbed_object.add_child(object)
		
	elif not _tranfer_object(object, area):
		
		if area.has_method("insert_object"):
			
			object.origin = get_parent().get_parent()
			pos_grabbed_object.remove_child(object)
			
			if not area.call("insert_object", object):
				pos_grabbed_object.add_child(object)

func _drop_object() -> void:
	var object: PickableObject = pos_grabbed_object.get_child(0)
	
	pos_grabbed_object.remove_child(object)
	object.origin = get_parent().get_parent()
	object.drop(global_position + (_last_direction * 10))

func _tranfer_object(object: PickableObject, area: Area2D) -> bool:
	var was_transfered: bool
	
	if object.has_method("transfer_ingredient"):
		
		if object.call("transfer_ingredient", area):
			was_transfered = true
	
	return was_transfered

func _fire_action(area: Area2D):
	
	if area.has_method("cut_ingridient"):
		
		if area.cut_ingridient():
			is_interacting = true
		
	elif area.has_method("wash_plate"):
		
		area.wash_plate()
		is_interacting = true
	
	if is_interacting:
		assert(area.get_node("WorkTimer").connect("timeout", self, "_stop_interaction", [area.get_node("WorkTimer")]) == OK) # REFACTOR

func _stop_action(area: Area2D):
	
	if area.has_method("stop_cutting"):
		area.stop_cutting()
	
	if area.has_method("stop_washing"):
		area.stop_washing()
	
	_stop_interaction(area.get_node("WorkTimer"))

func _stop_interaction(timer: Timer):

	is_interacting = false
	timer.disconnect("timeout", self, "_stop_interaction")

# @setters
func set_controller_index(value: int) -> void:
	
	up = str("player", value, "_move_up")
	down = str("player", value, "_move_down")
	left = str("player", value, "_move_left")
	right = str("player", value, "_move_right")
	primary_action = str("player", value, "_primary_action")
	secoundary_action = str("player", value, "_secoundary_action")
	
	controller_index = value

