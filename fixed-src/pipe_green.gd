extends Node2D

@export var max_speed = 170.0
@export var gap_size = 190.0
@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe
@onready var score_area = $ScoreArea

var score_added = false

func _ready():
	z_index = 10

	# Force both pipes to use the same green texture at runtime.
	# This also protects the Android build from any stale resource mapping.
	var green_texture = load("res://pipe-green.png")
	$TopPipe/Sprite2D.texture = green_texture
	$BottomPipe/Sprite2D.texture = green_texture

	var view_height = get_viewport_rect().size.y
	var gap_center = randf_range(250.0, view_height - 300.0)
	var half_pipe_height = 400.0

	top_pipe.position.y = gap_center - gap_size / 2.0 - half_pipe_height
	bottom_pipe.position.y = gap_center + gap_size / 2.0 + half_pipe_height
	score_area.position.y = gap_center

func _process(delta):
	position.x -= max_speed * delta
	if position.x < -120.0:
		queue_free()

func _on_score_area_body_entered(body):
	if body.name == "CharacterBody2D" and not score_added:
		score_added = true
		get_tree().current_scene.add_score()
