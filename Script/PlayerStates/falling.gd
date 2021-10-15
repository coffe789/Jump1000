extends PlayerState

func do_state_logic(delta):
	check_buffered_jump_input()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.is_on_floor()):
		if (Input.is_action_pressed("left") || Input.is_action_pressed("right")):
			return "running"
		else:
			return "idle"
	if (Input.is_action_just_pressed("jump") && Player.canCoyoteJump):
		return "jumping"
	if ((Input.is_action_just_pressed("jump") || Player.isJumpBuffered) && can_wall_jump()):
		return "walljumping"
	return "falling"
