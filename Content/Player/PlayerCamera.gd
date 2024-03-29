tool
extends Camera2D

const LOWER_OFFSCREEN_MARGIN = 0#4
const DEFAULT_SMOOTH_SPEED = 6

var is_player_connected = false
var Player = null
var cam_offset = Vector2.ZERO

func _ready():
	if !Engine.editor_hint:
		reset_smoothing()
		Globals.connect("player_connect_cam", self, "_on_player_connected")
		Globals.connect("player_freed", self, "_on_player_disconnected")
		Globals.connect("set_camera_offset", self, "_set_offset")
		Globals.connect("set_cam_limit", self, "_set_limits")


func set_camera_limits(room_shape):
	var room_size = room_shape.shape.extents * 2
	limit_left = room_shape.global_position.x - room_size.x / 2
	limit_top = room_shape.global_position.y - room_size.y / 2
	limit_right = limit_left + room_size.x
	limit_bottom = limit_top + room_size.y - LOWER_OFFSCREEN_MARGIN


func _on_player_connected(player):
	if !Player: # Only reset camera if new player is spawned
		reset_smoothing()
	is_player_connected = true
	Player = player
	global_position = Player.global_position + cam_offset



# Using physics because I had a bug earlier that was solved by syncing camera to physics
func _physics_process(_delta):
	if is_player_connected:
		global_position = Player.global_position + cam_offset


func _process(_delta):
	if Engine.editor_hint:
		if get_tree().get_nodes_in_group("player") != []:
			global_position = get_tree().get_nodes_in_group("player")[0].global_position


func _on_player_disconnected():
	is_player_connected = false


func _set_offset(new_offset, ignore_X_or_Y):
	if !ignore_X_or_Y.x:
		cam_offset.x = new_offset.x
	if !ignore_X_or_Y.y:
		cam_offset.y = new_offset.y

func _set_limits(limit_type, limit_pos):
	if limit_type == 0: # let cam go left
		limit_right = limit_pos
	elif limit_type == 1: # let cam go right
		limit_left = limit_pos
		limit_left = limit_pos
	elif limit_type == 2: # above
		limit_bottom = limit_pos
	elif limit_type == 3: #below
		limit_top = limit_pos
