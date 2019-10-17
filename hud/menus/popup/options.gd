extends WindowDialog


func _ready():
	
	assert(Game.connect("volume_changed", self, "_on_Game_volume_changed") == OK)
	assert(Game.connect("mute_toggled", self, "_on_Game_mute_toggled") == OK)
	assert(Game.connect("fullscreen_mode_changed", self, "_on_Game_fullScreen_mode_changed") == OK)
	$MarginContainer/List/Volume/HSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$MarginContainer/List/FullScreen.pressed = OS.window_fullscreen
	

# Video
func _on_Game_fullScreen_mode_changed():
	
	$MarginContainer/List/FullScreen.pressed = OS.window_fullscreen
	get_tree().get_root().set_transparent_background(!OS.window_fullscreen)
	OS.window_per_pixel_transparency_enabled = !OS.window_fullscreen

func _on_FullScreen_toggled(button_pressed: bool) -> void:
	
	if OS.window_fullscreen != button_pressed:
		Game.set_fullscreen(button_pressed)

# Audio
func _on_Game_volume_changed(channel: int, value: float) -> void:
	
	match AudioServer.get_bus_name(channel):
		"Master":
			$MarginContainer/List/Volume/HSlider.value = value

func _on_Game_mute_toggled(channel: int, value: bool) -> void:
	
	match AudioServer.get_bus_name(channel):
		"Master":
			$MarginContainer/List/Volume/Mute.pressed = value


func _on_Volume_HSlider_value_changed(value: float) -> void:
	
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) != value:
		Game.set_volume(value)

func _on_Mute_toggled(button_pressed: bool) -> void:
	
	if AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")) != button_pressed:
		Game.mute_toggle()

# @main
func focus_first():
	$MarginContainer/List/FullScreen.grab_focus()
