extends ParallaxLayer
export var speed = 0.2

#func _ready():
#	position.x += 512

var can_loop = true

func _process(delta):
	motion_offset.x -= speed
#	if int(position.x) % 512 ==0 and can_loop:
#		position.x += 512
#		can_loop = false
#	elif int(position.x) % 256:
#		can_loop = true
