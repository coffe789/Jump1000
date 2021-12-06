extends Camera2D
onready var Player = get_parent()
var smooth_speed = 5
const FREEZE_TIME = 0.6

#Called when player enters a room area
func do_room_transition(area):
	if Player.current_room == null: #Upon booting the game or something
		set_player_room(area)
	elif area != Player.current_room:
		var player_location = Player.get_node("CollisionChecks/RoomDetection")
		if area != Player.current_room:
			if player_location.global_position.y < limit_top:#up
				Player.velocity.y = -230
				Player.stop_jump_rise = true #letting go of jump doesn't nullify new velocity
			elif player_location.global_position.y > limit_bottom:#down transition
				pass
			elif player_location.global_position.x < limit_left: #left transition
				pass
			elif player_location.global_position.x > limit_right:#right transition
				pass
		
		var room_collision_shape = area.get_node("CollisionShape2D")
		var room_size = room_collision_shape.shape.extents*2
		
		#set camera
		limit_left = room_collision_shape.global_position.x - room_size.x / 2
		limit_top = room_collision_shape.global_position.y - room_size.y / 2
		limit_right = limit_left + room_size.x
		limit_bottom = limit_top + room_size.y
		
		area.enter_room()
		do_transition_pause(area)
		yield(get_tree().create_timer(FREEZE_TIME), "timeout")
		Player.current_room.exit_room()
		Player.current_room = area
	



#momentarily pauses the game while transitioning rooms
func do_transition_pause(area):
	if area != Player.current_room:
		pause_mode = Node.PAUSE_MODE_PROCESS
		get_tree().paused = true
		var timers_to_pause = get_tree().get_nodes_in_group("reset_on_room_transition")
		for i in timers_to_pause.size():
			timers_to_pause[i].start(0) #maybe stops timer
		Player.isJumpBuffered = false
		Player.canCoyoteJump = false
		yield(get_tree().create_timer(FREEZE_TIME), "timeout")
		get_tree().paused = false

func set_player_room(area):
	Player.current_room = area
	Player.current_room.enter_room()
	#set camera
	var room_collision_shape = area.get_node("CollisionShape2D")
	var room_size = room_collision_shape.shape.extents*2
	limit_left = room_collision_shape.global_position.x - room_size.x / 2
	limit_top = room_collision_shape.global_position.y - room_size.y / 2
	limit_right = limit_left + room_size.x
	limit_bottom = limit_top + room_size.y
	reset_smoothing()
