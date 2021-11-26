extends PlayerState


func do_state_logic(delta):
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED * WALL_GRAVITY_FACTOR, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)

func check_for_new_state() -> String:
	_update_wall_direction()
	if (Player.is_on_floor()):
		return "idle"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "walljumping"
	if (get_ledge_behaviour() != Globals.LEDGE_EXIT):
			return "ledgeclinging"
	if Player.wall_direction == get_input_direction() && Player.wall_direction != 0:
		return "wallsliding"
	else:
		return "falling"

func set_cape_acceleration():
	Player.Cape.accel = Vector2(0, 8)
