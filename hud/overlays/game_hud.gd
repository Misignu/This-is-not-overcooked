tool
extends CanvasLayer

const MOVE_STACK_TIME = 1.5

export(int, 5, 360) var order_min_frequency := 10
export(int, 5, 360) var order_max_frequency := 25
export(int, 5, 360) var clients_min_wait_time := 20
export(int, 5, 360) var clients_max_wait_time := 25
export(int, 10, 6000, 5) var limit_time := 60
export(int, 0, 9990, 10) var level_coins := 50

var is_sliding: bool
var order = preload("res://hud/overlays/order.tscn")
var references := Array()

func _ready():
	randomize()
	
	if not Engine.is_editor_hint():
		
		assert(Game.connect("coins_changed", self, "_on_Game_coins_changed") == OK)
		Game.coins = level_coins
		$LimitTimer.start(limit_time)
		call_deferred("_update_references")
		call_deferred("_add_new_order")

func _process(_delta):
	
	$CenterContainer/MarginContainer/Countdown/Label.text = int($LimitTimer.time_left) as String

# @signals
func _on_Game_coins_changed(value: int, loss: float) -> void:
	
	if loss:
		
		$AudioStreamPlayer.play()
	
	$MarginContainer/HBoxContainer/CenterContainer/Coins/Label.text = str(value)

func _on_NewOrderTimer_timeout():
	
	if is_sliding:
		$NewOrderTimer.start(MOVE_STACK_TIME)
		
	else:
		_add_new_order()

func _on_LimitTimer_timeout():
	assert(get_tree().change_scene("res://hud/eyecatchers/victory.tscn") == OK)

func _on_SlideTimer_timeout():
	is_sliding = false

func _on_new_order_AnimationPlayer_animation_finished(animation, position2d: Position2D) -> void:
	
	if animation == "done":
		_move_stack(position2d)

func _on_Treadmill_recipe_delived():
	_order_complete("Hamburger")

#  @main
func _update_references():
	var reference: Node2D
	
	for container in $MarginContainer/HBoxContainer/OrderPad.get_children():
		
		reference = container.get_node("Reference")
		reference.get_node("Position2D").stack_id = reference.get_parent().get_index()
		references.append(reference)

func _add_new_order():
	
	var new_order = order.instance()
	var reference := _get_empty_reference()
	var reference_position2d: Position2D
	
	new_order.get_node("LimitTimer").wait_time = rand_range(clients_min_wait_time, clients_max_wait_time)
	
	if reference != null: # Se o limite de slots não for atingido
		
		reference_position2d = reference.get_node("Position2D")
		reference_position2d.add_child(new_order)
		
		assert(
			new_order.get_node("AnimationPlayer").connect(
				"animation_finished", 
				self, "_on_new_order_AnimationPlayer_animation_finished", 
				[reference_position2d]
			) == OK
		)
	
	$NewOrderTimer.start(rand_range(order_min_frequency, order_max_frequency))

func _order_complete(recipe: String): # DEBUG
	var completed := false
	var order_reference: NinePatchRect
	
	for reference in references:
		
		if reference.has_node("Order"):
			order_reference = reference.get_node("Order")
			
			if recipe in order_reference.name:
				
				order_reference.complete()
				completed = true
				break
	
	if not completed:
		$AnimationPlayer.play("wrong_recipe")

func _move_stack(base_position_2d: Position2D):
	var counter: int = 0
	
	for current_position2d in _get_next_orders_siblings_position2ds(base_position_2d):
		
		current_position2d.stack_id = current_position2d.stack_id -1
		counter += 1
	
	base_position_2d.stack_id += counter
	_moving_stack()
	
#	var tween_reference: Tween
##	var position2d_reference: Position2D
#	var last_reference_position2d: Position2D
#	var new_stack_id: int
#
#	for current_position2d in _get_next_orders_siblings_position2ds(base_position_2d):
#
#		last_reference_position2d = current_position2d
#		tween_reference = current_position2d.get_parent().get_node("Tween")
#		new_stack_id = current_position2d.get_node("Order").stack_id - 1
#
#		current_position2d.get_node("Order").stack_id = new_stack_id

#
#	base_position_2d.position = references[last_reference_position2d.get_node("Order").stack_id].global_position - base_position_2d.global_position

func _moving_stack() -> void:
	var current_position2d: Position2D
	
	# /// WATCH
	var stack_id: int
	var stacked_reference_gpos: Vector2
	var target_pos: Vector2
#	var final_pos: Vector2
	# ///
	
	for reference in references:
		
		current_position2d = reference.get_node("Position2D")
		
		stack_id = current_position2d.stack_id
		stacked_reference_gpos = references[stack_id].global_position
		
		target_pos = stacked_reference_gpos - current_position2d.get_parent().global_position
#		final_pos = target_pos + current_position2d.global_position
		
#		print(str("The [", reference.get_parent().name, "] position2d id is : ", stack_id))
		
		_slide_position2d(current_position2d, reference.get_node("Tween"), target_pos)
		is_sliding = true
	
	if is_sliding:
		
		$SlideTimer.start(MOVE_STACK_TIME)

func _slide_position2d(target: Position2D, tween: Tween, position: Vector2) -> void:
	
	assert(
		tween.interpolate_property(
			target, "position", 
			target.position, 
			position,
			MOVE_STACK_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		and
		tween.start()
	)

func _get_empty_reference() -> Node2D:
	
	var value: Node2D
	var reference_position2d: Position2D

	for reference in references:
		reference_position2d = reference.get_node("Position2D")
		
		if not reference_position2d.has_node("Order"):
			
			if value != null:
				
				if reference_position2d.global_position < value.get_node("Position2D").global_position:
					value = reference
				
			else:
				value = reference

	return value

func _get_next_orders_siblings_position2ds(position2d: Position2D) -> Array:
	var siblings := Array()
	var reference_position2d: Position2D
	
	for reference in references:
		reference_position2d = reference.get_node("Position2D")
		
		if reference_position2d.global_position.x > position2d.global_position.x:
			
			if reference_position2d.has_node("Order"):
				
				siblings.append(reference_position2d)
	
	var test := Array()
	for sibling in siblings:
		test.append(sibling.get_parent().get_parent().name)
	
	return siblings

#func _get_previous_order_x_position(current_global_x_position: int) -> int: # DEBUG
#
#	var has_changed: bool
#	var x_position: int
#	var current_node_x_position: int
#	var bigger: int
#
#	for container in order_pad.get_children():
#		current_node_x_position = container.get_node("Node2D").global_position.x
#
#		if current_node_x_position < current_global_x_position:
#
#			if current_node_x_position > x_position:
#
#				x_position = current_node_x_position
#				has_changed = true
#		else:
#			bigger = current_node_x_position
#
#	if not has_changed:
#		x_position = bigger
#
#	return x_position - current_global_x_position

#func _get_previous_order_position2D(position_2d) -> Position2D:
#
#	var value: Position2D = references[0].get_node("Position2D")
#	var current_reference_position2d: Position2D
#
#	for reference in references:
#		current_reference_position2d = reference.get_node("Position2D")
#
#		if current_reference_position2d.global_position.x < position_2d.global_position.x:
#
#			if current_reference_position2d.global_position.x > value.global_position.x:
#				value = current_reference_position2d
#
#	return value


