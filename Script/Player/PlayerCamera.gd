extends Camera2D

onready var Player = get_parent()
const LOWER_OFFSCREEN_MARGIN = 4


func _ready():
	reset_smoothing()


func set_camera_limits(room_shape):
	var room_size = room_shape.shape.extents * 2
	limit_left = room_shape.global_position.x - room_size.x / 2
	limit_top = room_shape.global_position.y - room_size.y / 2
	limit_right = limit_left + room_size.x
	limit_bottom = limit_top + room_size.y - LOWER_OFFSCREEN_MARGIN
