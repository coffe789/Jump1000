extends ParallaxLayer
export var speed = Vector2(-0.2,0)

func _process(delta):
	motion_offset += speed
