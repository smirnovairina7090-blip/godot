extends Node2D

@export var scene: PackedScene
@onready var score_label = $CanvasLayer/Label
@onready var timer = $Timer
@onready var bird = $CharacterBody2D
@onready var background = $ParallaxBackground/ParallaxLayer/Background
@onready var background_layer = $ParallaxBackground/ParallaxLayer
@onready var ground = $ParallaxBackground2/ParallaxLayer2/Ground
@onready var ground_layer = $ParallaxBackground2/ParallaxLayer2
@onready var ground_body = $GroundBody

var score = 0
var game_started = false

func _ready():
	randomize()
	_setup_layout()
	score_label.text = "0"
	timer.stop()
	timer.wait_time = 1.65

func _setup_layout():
	var view_size = get_viewport_rect().size

	var bg_size = background.texture.get_size()
	background.position = Vector2.ZERO
	background.scale = Vector2(view_size.x / bg_size.x, view_size.y / bg_size.y)
	background_layer.motion_mirroring = Vector2(view_size.x, 0)

	var ground_size = ground.texture.get_size()
	ground.position = Vector2(0, view_size.y - ground_size.y)
	ground.scale = Vector2(view_size.x / ground_size.x, 1.0)
	ground_layer.motion_mirroring = Vector2(view_size.x, 0)

	ground_body.position = Vector2(view_size.x / 2.0, view_size.y - ground_size.y / 2.0)
	bird.position = Vector2(view_size.x * 0.28, view_size.y * 0.43)

func start_game():
	if game_started:
		return
	game_started = true
	_spawn_pipe()
	timer.start()

func add_score():
	score += 1
	score_label.text = str(score)

func _spawn_pipe():
	var pipe = scene.instantiate()
	add_child(pipe)
	pipe.position = Vector2(get_viewport_rect().size.x + 90.0, 0)

func _on_timer_timeout():
	_spawn_pipe()
	timer.wait_time = randf_range(1.55, 1.78)
