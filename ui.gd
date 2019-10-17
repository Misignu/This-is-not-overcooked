"""
General Singleton that Pack some Classes that deals with some UI behaviors
"""

class Audio extends Node:
	"""
	General Singleton Class that deals with Audio.
	"""
	signal volume_changed
	signal mute_toggled
	
	const VOLUME_STEP = 10
	
	func increase_volume(channel: int = AudioServer.get_bus_index("Master")):
		
		set_volume(AudioServer.get_bus_volume_db(channel)  + VOLUME_STEP, channel)
	
	func decrease_volume(channel: int = AudioServer.get_bus_index("Master")):
		
		set_volume(AudioServer.get_bus_volume_db(channel)  - VOLUME_STEP, channel)
	
	func set_volume(value: float, channel: int = AudioServer.get_bus_index("Master")) -> void:
		
		var is_muted := AudioServer.is_bus_mute(channel)
		var mute := is_muted
		
		if value < -80:
			
			if not is_muted:
				mute = true
			
		elif value <= 0:
			
			AudioServer.set_bus_volume_db(channel, value)
#			print(str(AudioServer.get_bus_name(channel), " Volume %", (value * 100) / 80))
			
			print("Volume ", value)
			emit_signal("volume_changed", channel, value)
			
			if is_muted:
				mute = false
		
		if is_muted != mute:
			
			mute_toggle(channel)
	
	func mute_toggle(channel: int = AudioServer.get_bus_index("Master")):
		var value = not AudioServer.is_bus_mute(channel)
		
		print("Mute was togled to: ", value)
		AudioServer.set_bus_mute(channel, value)
		emit_signal("mute_toggled", channel, value)

class Video extends Audio:
	"""
	General Singleton Class Deals with Video
	"""
	signal fullscreen_mode_changed
	
	func set_transparency_mode(value := false):
		
		get_tree().get_root().set_transparent_background(false)
		OS.window_per_pixel_transparency_enabled = value
		OS.window_borderless = value
	
	func set_fullscreen(mode: bool = !OS.window_fullscreen):
		
		OS.window_fullscreen = mode
		emit_signal("fullscreen_mode_changed")
