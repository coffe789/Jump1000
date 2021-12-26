tool
extends Camera2D

const LOWER_OFFSCREEN_MARGIN = 0#4
const DEFAULT_SMOOTH_SPEED = 6

var is_player_connected = false
var Player = null


func _ready():
	if !Engine.editor_hint:
		reset_smoothing()
		Globals.connect("player_connect_cam", self, "_on_player_connected")
		Globals.connect("player_freed", self, "_on_player_disconnected")


func set_camera_limits(room_shape):
	var room_size = room_shape.shape.extents * 2
	limit_left = room_shape.global_position.x - room_size.x / 2
	limit_top = room_shape.global_position.y - room_size.y / 2
	limit_right = limit_left + room_size.x
	limit_bottom = limit_top + room_size.y - LOWER_OFFSCREEN_MARGIN
	print(limit_right)


func _on_player_connected(player):
	is_player_connected = true
	Player = player
	global_position = Player.global_position
	reset_smoothing()


# Using physics because I had a bug earlier that was solved by syncing camera to physics
func _physics_process(delta):
	if is_player_connected:
		global_position = Player.global_position

func _process(delta):
	if Engine.editor_hint:
		if get_tree().get_nodes_in_group("player") != []:
			global_position = get_tree().get_nodes_in_group("player")[0].global_position

func _on_player_disconnected():
	is_player_connected = false


