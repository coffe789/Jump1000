extends PlayerState

func do_state_logic(_delta):
	start_coyote_time()
	Player.velocity.y = 0
	Player.input_acceleration.x = get_input_direction() * ACCELERATE_WALK
	Player.external_acceleration.y = GRAVITY
	apply_drag()
	clamp_movement()
	Player.velocity += get_total_acceleration()
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "jumping"
	if (!Player.is_on_floor()):
		return "falling"
	if (!Input.is_action_pressed("left") && !Input.is_action_pressed("right")):
		return "idle"
	return "running"
