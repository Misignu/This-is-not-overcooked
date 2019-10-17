extends Camera2D

func _physics_process(_delta):
	
	if Input.is_action_pressed("ui_up"):
		position += Vector2.UP * 10
	
	if Input.is_action_pressed("ui_down"):
		position += Vector2.DOWN * 10
	
	if Input.is_action_pressed("ui_left"):
		position += Vector2.LEFT * 10
	
	if Input.is_action_pressed("ui_right"):
		position += Vector2.RIGHT * 10
	
	if Input.is_action_pressed("ui_page_down"):
		zoom = Vector2(.25, .25)
	
	if Input.is_action_pressed("ui_page_up"):
		zoom = Vector2(1,1)
	
	
