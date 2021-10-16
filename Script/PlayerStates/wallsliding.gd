extends PlayerState

func do_state_logic(delta):
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY/400)
	#do_normal_x_movement(delta,AIR_DRAG)
	Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.is_on_floor()):
		return "idle"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "walljumping"
	if not can_wall_jump() and not Player.canCoyoteJump:
		return "falling"
	else:
		return "wallsliding"
