extends Camera2D

onready var Player = get_parent()
const FREEZE_TIME = 0.6
const LOWER_OFFSCREEN_MARGIN = 4
const UP_TRANSITION_BOOST = -230

func set_camera_limits(room_shape):
	var room_size = room_shape.shape.extents * 2
	limit_left = room_shape.global_position.x - room_size.x / 2
	limit_top = room_shape.global_position.y - room_size.y / 2
	limit_right = limit_left + room_size.x
	limit_bottom = limit_top + room_size.y - LOWER_OFFSCREEN_MARGIN


func check_transition_type():
	var player_location = Player.get_node("CollisionChecks/RoomDetection")
	if player_location.global_position.y < limit_top: # up transition
		if Player.velocity.y > UP_TRANSITION_BOOST:
			Player.velocity.y = UP_TRANSITION_BOOST
			Player.stop_jump_rise = true # Letting go of jump doesn't nullify new velocity
	elif player_location.global_position.y > limit_bottom: # down transition
		pass
	elif player_location.global_position.x < limit_left: # left transition
		pass
	elif player_location.global_position.x > limit_right: # right transition
		pass

# Called when player enters a room area
func do_room_transition(area):
	if Player.current_room == null:
		set_player_room(area)
	elif area != Player.current_room:
		check_transition_type()
		
		var room_collision_shape = area.get_node("CollisionShape2D")
		set_camera_limits(room_collision_shape)
		
		area.enter_room()
		snap_player_to_room()
		do_transition_pause(area)
		yield(get_tree().create_timer(FREEZE_TIME), "timeout")
		Player.current_room.exit_room()
		Player.current_room = area


# Momentarily pauses the game while transitioning rooms
func do_transition_pause(area):
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().get_nodes_in_group("verlet_area")[0].pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	var timers_to_pause = get_tree().get_nodes_in_group("reset_on_room_transition")
	for i in timers_to_pause.size():
		timers_to_pause[i].start(0) # maybe stops timer
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	yield(get_tree().create_timer(FREEZE_TIME/3), "timeout")
	get_tree().get_nodes_in_group("verlet_area")[0].pause_mode = Node.PAUSE_MODE_INHERIT # temporary (bad) dejanking of cape during transitions
	yield(get_tree().create_timer(2*FREEZE_TIME/3), "timeout")
	get_tree().paused = false


# Forcibly sets room. Used on the first room upon spawning so that the camera locks instantly
func set_player_room(area):
	Player.current_room = area
	Player.current_room.enter_room()
	
	# Set camera limits/position
	var room_collision_shape = area.get_node("CollisionShape2D")
	set_camera_limits(room_collision_shape)
	reset_smoothing()


var snap_fatness = 5
var snap_height = 9
func snap_player_to_room():
	if Player.position.x - snap_fatness < limit_left:
		Player.position.x = limit_left + snap_fatness
	elif Player.position.x + snap_fatness > limit_right:
		Player.position.x = limit_right - snap_fatness
	
	if Player.position.y - snap_height < limit_top:
		Player.position.y = limit_top + snap_height
	elif Player.position.y + snap_height > (limit_bottom + LOWER_OFFSCREEN_MARGIN):
		Player.position.y = limit_bottom - snap_height
