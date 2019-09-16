tool
extends CanvasLayer

export(int, 5, 360) var clients_min_wait_time := 25
export(int, 5, 360) var clients_max_wait_time := 20
export(int, 5, 360) var order_min_frequency := 10
export(int, 5, 360) var order_max_frequency := 25
export(int, 10, 6000, 5) var limit_time := 60

export(int, 0, 9990, 10) var level_coins = 50

var order = preload("res://hud/overlays/order.tscn")
var orders := Array()

func _process(_delta):
	
	$CenterContainer/MarginContainer/Countdown/Label.text = int($LimitTimer.time_left) as String

func _ready():
#	$MarginContainer/OrderPad/Order.call_deferred("set_rect_size", $MarginContainer/OrderPad/Order/MarginContainer.rect_size)
	if not Engine.is_editor_hint():
		
		assert(Game.connect("coins_changed", self, "_on_Game_coins_changed") == OK)
		Game.coins = level_coins
		_add_new_order()
		$LimitTimer.start(limit_time)
		randomize()

func _on_Timer_timeout():
	_add_new_order()

func _on_LimitTimer_timeout():
	assert(get_tree().change_scene("res://hud/eyecatchers/victory.tscn") == OK)

func _add_new_order():
	var new_order = order.instance()
	
	new_order.id = orders.front().id + 1 if orders.size() > 0 else 0 # TODO REFACTOR AND DEBUG
	new_order.get_node("Timer").wait_time = rand_range(clients_min_wait_time, clients_max_wait_time)
	$Timer.start(rand_range(order_min_frequency, order_max_frequency))
	$MarginContainer/HBoxContainer/OrderPad.add_child(new_order)
	orders.append(new_order)

func _order_complete(recipe: String):
	var completed := false
	print("order complete: ", recipe)
	for current_order in orders:
		
		if recipe in current_order.name:
			
			current_order.complete()
			orders.remove(current_order.id)
			completed = true
			break
	
	if not completed:
		$AnimationPlayer.play("wrong_recipe")

func _on_Game_coins_changed(value: int, loss: float):
	
	if loss:
		
		$AudioStreamPlayer.play()
	
	$MarginContainer/HBoxContainer/CenterContainer/Coins/Label.text = str(value)

func _on_Treadmill_recipe_finished():
	_order_complete("Hamburger")
