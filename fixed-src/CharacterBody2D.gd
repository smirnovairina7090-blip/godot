extends CharacterBody2D

@export var gravity = 1250.0
@export var flap_strength = 460.0
@export var max_fallspeed = 700.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var game_over_lbl = $'../CanvasLayer/TextureRect'

var game_over = false
var started = false

func lose():
	if game_over:
		return

	game_over = true
	game_over_lbl.visible = true
	var sound = get_tree().current_scene.get_node("AudioStreamPlayer2D")
	sound.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	sound.play()
	await sound.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://start.tscn")

func _physics_process(delta):
	if game_over:
		return

	if started:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fallspeed)
		move_and_slide()
		rotation = lerp(rotation, clamp(velocity.y / 950.0, -0.38, 0.78), 8.0 * delta)
	else:
		rotation = 0.0

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("pipe"):
			lose()
			return

	if global_position.y <= 18.0:
		global_position.y = 18.0
		if velocity.y < 0.0:
			velocity.y = 0.0

	var floor_y = get_viewport_rect().size.y - 118.0
	if global_position.y >= floor_y:
		lose()

func flap():
	if game_over:
		return

	started = true
	if get_tree().current_scene.has_method("start_game"):
		get_tree().current_scene.start_game()
	velocity.y = -flap_strength
	animated_sprite.play("flap")

func _unhandled_input(event):
	if event.is_action_pressed("flap"):
		flap()

func _on_animated_sprite_2d_animation_finished():
	animated_sprite.play("default")
