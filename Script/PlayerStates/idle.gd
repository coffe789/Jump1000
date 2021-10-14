extends PlayerState

func do_state_logic(delta):
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,FLOOR_DRAG)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (!Player.is_on_floor()):
		return "falling"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "jumping"
	if (Input.is_action_pressed("left") || Input.is_action_pressed("right")):
		return "running"
	return "idle"
