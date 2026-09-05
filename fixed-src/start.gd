extends Node2D

@onready var background = $Background

func _ready():
	_fit_background()

func _fit_background():
	var view_size = get_viewport_rect().size
	var texture_size = background.texture.get_size()
	background.position = Vector2.ZERO
	background.scale = Vector2(view_size.x / texture_size.x, view_size.y / texture_size.y)

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")
