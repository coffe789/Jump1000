extends PlayerState
var ledge_behaviour

func enter(_arg):
	pass

func do_state_transition():
	pass

func get_ledge_Y():
	for i in 16: #(-5--13)*2
		ledge_cast_top.position.y += 0.5
		ledge_cast_top.force_raycast_update()
		if _check_is_valid_wall(ledge_cast_top):
			var ledge_pos = ledge_cast_top.global_position.y
			ledge_cast_top.position.y = -13 #initial value
			return ledge_pos

func do_state_logic(delta):
	check_if_finish_jump()
	print(get_ledge_behaviour())
	ledge_behaviour = get_ledge_behaviour()
	if ledge_behaviour == Globals.LEDGE_REST:
		if get_ledge_Y()-ledge_cast_top.global_position.y < 2:
			Player.velocity.y = 0
			Player.velocity.x = Player.move_and_slide(Player.velocity, UP_DIRECTION).x
		else:
			do_gravity(delta, MAX_FALL_SPEED * WALL_GRAVITY_FACTOR, GRAVITY * 1.5)
			do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
			Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)
	else:
		do_gravity(delta, MAX_FALL_SPEED * WALL_GRAVITY_FACTOR, GRAVITY)
		do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
		Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_cape_acceleration():
	Player.Cape.accel = Vector2(0, 8)

func check_for_new_state() -> String:
	_update_wall_direction()
	if (Player.is_on_floor()):
		return "idle"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "jumping"
#	if Player.wall_direction == get_input_direction() && Player.wall_direction != 0:
#		return "wallsliding"
	if ledge_behaviour == Globals.LEDGE_EXIT:
		return "falling"
	else:
		return "ledgeclinging"

