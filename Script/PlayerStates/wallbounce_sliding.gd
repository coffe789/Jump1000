extends PlayerState

func do_state_logic(delta):
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)

func check_for_new_state() -> String:
	_update_wall_direction()
	if (Player.is_on_floor()):
		return "idle"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "wallbouncing"
	if Player.wall_direction == get_input_direction() && Player.wall_direction != 0 && Player.velocity.y >= 0:
		return "wallsliding"
	if can_wall_jump() && Player.velocity.y < 0:
		return "wallbounce_sliding"
	return "falling"

