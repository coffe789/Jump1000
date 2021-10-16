extends PlayerState

func do_state_logic(delta):
	Animation_Player.play("running")
	start_coyote_time()
	Player.velocity.y = 0
	do_normal_x_movement(delta,FLOOR_DRAG)
	Player.velocity.y = 10
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "jumping"
	if (!Player.is_on_floor()):
		return "falling"
	if (get_input_direction()==0):
		return "idle"
	if ((Input.is_action_just_pressed("jump") || Player.isJumpBuffered) && Player.can_wall_jump()):
		return "walljumping"
	return "running"
