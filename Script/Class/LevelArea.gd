extends Node2D
class_name LevelArea

const FREEZE_TIME = 0.6 # When room transitioning
const UP_TRANSITION_BOOST = -230
const TRANSITION_CAMERA_SPEED = 7

func _init():
	self.add_to_group("area")


func _ready():
	yield(get_tree(), "idle_frame") # Collision polygons need a frame to settle
	initialise_rooms()
	Globals.get_player().collision_mask = Globals.get_player().collision_mask | 16 # enable room boundary collision after boundaries are created

func get_cam():
	assert(get_tree().get_nodes_in_group("player_camera") != [])
	return get_tree().get_nodes_in_group("player_camera")[0]

# Shapes the boundaries for all rooms based on their relative positions
func initialise_rooms():
	for room in get_tree().get_nodes_in_group("room"):
		for overlapping_body in room.get_overlapping_bodies():
			if overlapping_body.is_in_group("room_boundary") && overlapping_body.get_parent()!=room:
				var transformed_cutout_shape = PoolVector2Array([Vector2(),Vector2(),Vector2(),Vector2()]) # this is how you create a size 4 array in gdscript
				var pos_dif = room.global_position - overlapping_body.global_position # clip operation requires polygons to be in same coordiante space
				for i in range(0,4):
					transformed_cutout_shape[i] = room.cutout_shape[i] + pos_dif
				var new_poly = Geometry.clip_polygons_2d(overlapping_body.get_node("CollisionPolygon2D").polygon, transformed_cutout_shape)
				overlapping_body.get_node("CollisionPolygon2D").polygon = new_poly[0]
				if new_poly.size() > 1: # If polygon is split into 2+ pieces, create new static bodies
					for i in range(1,new_poly.size()):
						var bound = overlapping_body.get_parent().add_boundary(new_poly[i])
						var diff = bound.global_position - overlapping_body.global_position
						for j in range(0,bound.get_child(0).polygon.size()): # clip operation only gets new shape, not position, so we set it ourselves
							bound.get_child(0).polygon[j]-=diff
	for room in get_tree().get_nodes_in_group("room"):
		room.cutout_shapes()
		room.cutout_killboxes()
	for node in get_tree().get_nodes_in_group("room_boundary"): # All bounds are disabled by default. We wait until now to disable them so clipping works
		if node is StaticBody2D:
			node.get_child(0).call_deferred("set_disabled",true)
	if Globals.get_player().current_room:
		Globals.get_player().current_room.enable_bounds(true)


# Called when player enters a room area
func do_room_transition(area):
	if Globals.get_player().current_room == null:
		set_player_room(area)
	elif area != Globals.get_player().current_room:
		var old_room = Globals.get_player().current_room
		check_transition_type()
		
		var room_collision_shape = area.get_node("CollisionShape2D")
		get_cam().smoothing_speed = TRANSITION_CAMERA_SPEED
		get_cam().set_camera_limits(room_collision_shape)
		
		snap_player_to_room()
		area.enter_room()
		Globals.get_player().current_room = area
		
		Globals.get_player().current_area.do_transition_pause()
		yield(get_tree().create_timer(FREEZE_TIME), "timeout")
		old_room.exit_room()
		get_cam().smoothing_speed = get_cam().DEFAULT_SMOOTH_SPEED


# Momentarily pauses the game while transitioning rooms
func do_transition_pause():
	get_cam().pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	var timers_to_pause = get_tree().get_nodes_in_group("reset_on_room_transition")
	for i in timers_to_pause.size():
		timers_to_pause[i].start(0) # maybe stops timer
	Globals.get_player().isJumpBuffered = false
	Globals.get_player().canCoyoteJump = false
	yield(get_tree().create_timer(FREEZE_TIME), "timeout")
	get_tree().paused = false
	get_cam().pause_mode = Node.PAUSE_MODE_INHERIT


func check_transition_type():
	var player_center = Globals.get_player().get_node("CollisionChecks/RoomDetection")
	if player_center.global_position.y < get_cam().limit_top + 1: # up transition
		if Globals.get_player().velocity.y > UP_TRANSITION_BOOST:
			Globals.get_player().velocity.y = UP_TRANSITION_BOOST
			Globals.get_player().stop_jump_rise = true # Letting go of jump doesn't nullify new velocity
	elif player_center.global_position.y > get_cam().limit_bottom - 1: # down transition
		pass
	elif player_center.global_position.x < get_cam().limit_left: # left transition
		pass
	elif player_center.global_position.x > get_cam().limit_right: # right transition
		pass


var snap_fatness = 5
var snap_up_height = 2
var snap_down_height = 14
func snap_player_to_room():
	var init_pos = Globals.get_player().position
	if Globals.get_player().position.x - snap_fatness < get_cam().limit_left:
		Globals.get_player().position.x = get_cam().limit_left + snap_fatness
	elif Globals.get_player().position.x + snap_fatness > get_cam().limit_right:
		Globals.get_player().position.x = get_cam().limit_right - snap_fatness
	
	if Globals.get_player().position.y - snap_down_height < get_cam().limit_top:
		Globals.get_player().position.y = get_cam().limit_top + snap_down_height
	elif Globals.get_player().position.y + snap_up_height > (get_cam().limit_bottom + get_cam().LOWER_OFFSCREEN_MARGIN):
		Globals.get_player().position.y = get_cam().limit_bottom - snap_up_height
		if Globals.get_player().velocity.y > UP_TRANSITION_BOOST:
			Globals.get_player().velocity.y = UP_TRANSITION_BOOST
			Globals.get_player().stop_jump_rise = true # Letting go of jump doesn't nullify new velocity
	
	# Move the cape too
	var diff_pos = Globals.get_player().position - init_pos
	Globals.get_player().Cape.position += diff_pos
	for cape_point in get_tree().get_nodes_in_group("cape_point"):
		cape_point.position += diff_pos
		cape_point.last_position = cape_point.position # Stop verlet physics from jerking


# Forcibly sets room. Used on the first room upon spawning so that the camera locks instantly
func set_player_room(area):
	Globals.get_player().current_room = area
	Globals.get_player().current_room.enter_room()
	
	# Set camera limits/position
	var room_collision_shape = area.get_node("CollisionShape2D")
	get_cam().set_camera_limits(room_collision_shape)
	get_cam().reset_smoothing()
