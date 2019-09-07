tool
extends Node2D

export var radius: float = 7.5 setget set_radius
export var color: Color = Color(.85, .8, 1) setget set_color

func _draw():
	
	if get_parent().texture != null or Engine.editor_hint:
		
		draw_circle(Vector2.ZERO, radius, color)

func _on_PickableObjectSprite_texture_changed():
	update()

# @setters
func set_radius(value: float) -> void:
	
	radius = value
	update()

func set_color(value: Color) -> void:
	
	color = value
	update()
