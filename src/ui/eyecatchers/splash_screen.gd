extends ColorRect

func _ready():
	get_tree().paused = true

func _on_Anim_animation_finished(_anim_name) -> void:
	get_tree().paused = false

func _on_TitleScreen_game_mode_started(next_scene: String) -> void:
	assert(get_tree().change_scene(next_scene) == OK)
