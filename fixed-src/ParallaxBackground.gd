extends ParallaxBackground

@export var max_speed = 35.0

func _process(delta):
	scroll_offset.x -= max_speed * delta
