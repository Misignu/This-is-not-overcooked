extends WindowDialog

onready var tween := $Tween
onready var scroll_box := $MarginContainer/ScrollContainer
onready var volume_slider := $MarginContainer/ScrollContainer/MarginContainer/List/Volume/HSlider

onready var full_screen_checkbox := $MarginContainer/ScrollContainer/MarginContainer/List/FullScreen/CheckBox
onready var mute_checkbox := $MarginContainer/ScrollContainer/MarginContainer/List/Volume/Mute

onready var show_channels_button := $MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel/VBoxContainer/show

onready var music_mute := $MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel/VBoxContainer/MarginContainer/Channels/Music/Mute
onready var sfx_mute := $MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel/VBoxContainer/MarginContainer/Channels/SFXS/Mute
onready var bsfx_mute := $MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel/VBoxContainer/MarginContainer/Channels/BSFXS/Mute

func _ready() -> void:
	
	assert(
		Game.connect("volume_changed", self, "_on_Game_volume_changed") == OK and
		Game.connect("mute_toggled", self, "_on_Game_mute_toggled") == OK and
		Game.connect("fullscreen_mode_changed", self, "_on_Game_fullScreen_mode_changed") == OK
	)
	_sliders_setup(volume_slider)
	_sliders_setup($MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel/VBoxContainer/MarginContainer/Channels/Music/HSlider)
	_sliders_setup($MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel/VBoxContainer/MarginContainer/Channels/SFXS/HSlider)
	_sliders_setup($MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel/VBoxContainer/MarginContainer/Channels/BSFXS/HSlider)
	full_screen_checkbox.pressed = OS.window_fullscreen

# @signals
func _on_Game_fullScreen_mode_changed() -> void:
	
	full_screen_checkbox.pressed = OS.window_fullscreen
	get_tree().get_root().set_transparent_background(!OS.window_fullscreen)
	OS.window_per_pixel_transparency_enabled = !OS.window_fullscreen

func _on_Game_volume_changed(channel: int, volume: float) -> void:
	var value = db2linear(volume)
	
	if AudioServer.get_bus_name(channel) == "Master" and value != volume_slider.value:
		volume_slider.value = value

func _on_Game_mute_toggled(channel: int, value: bool) -> void:
	
	match AudioServer.get_bus_name(channel):
		
		"Master":
			mute_checkbox.pressed = value
			
		"Music":
			music_mute.pressed = value
			
		"SFXS":
			sfx_mute.pressed = value
			
		"BSFXS":
			bsfx_mute.pressed = value

func _on_FullScreen_toggled(button_pressed: bool) -> void:
	
	if OS.window_fullscreen != button_pressed:
		Game.set_fullscreen(button_pressed)

func _on_Mute_toggled(button_pressed: bool, channel_name: String) -> void:
	
	if AudioServer.is_bus_mute(AudioServer.get_bus_index(channel_name)) != button_pressed:
		Game.mute_toggle(AudioServer.get_bus_index(channel_name))

func _on_HSlider_value_changed(value: float, channel_name: String) -> void:
	var volume = linear2db(value)
	
	Game.set_volume(volume, AudioServer.get_bus_index(channel_name))

func _on_Panel_panel_inclodded() -> void: # TODO -> Aperfeiçoar código. Fazer a chamada de sinal somente após o painel tiver eclodido ou inclodido
	
	tween.stop(scroll_box, "scroll_vertical")
	tween.interpolate_property(scroll_box, "scroll_vertical", scroll_box.scroll_vertical, 0, .5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	show_channels_button.focus_next = full_screen_checkbox.get_path()
	show_channels_button.focus_neighbour_bottom = full_screen_checkbox.get_path()
	

func _on_Panel_panel_eclodded() -> void:
	var music_path = $MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel/VBoxContainer/MarginContainer/Channels/Music.get_path()
	
	tween.interpolate_property(scroll_box, "scroll_vertical", scroll_box.scroll_vertical, 90, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	show_channels_button.focus_next = music_path
	show_channels_button.focus_neighbour_bottom = music_path
	$MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel/VBoxContainer/MarginContainer/Channels/Music/HSlider.grab_focus()

func _on_FullScreen_focus_entered() -> void:
	$MarginContainer/ScrollContainer/MarginContainer/List/SoundChannels/Panel.is_expanded = false

# @main
func focus_first() -> void: # WATCH -> Verificar o uso
	full_screen_checkbox.grab_focus()

static func _sliders_setup(slider: HSlider) -> void:
	
	slider.min_value = 0.0001
	slider.max_value = 1
	slider.step = 0.1
