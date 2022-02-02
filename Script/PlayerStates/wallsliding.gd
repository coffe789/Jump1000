extends PlayerState


func do_state_logic(delta):
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED * WALL_GRAVITY_FACTOR, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)

func check_for_new_state() -> String:
	_update_wall_direction()
	var ledge_behaviour = get_ledge_behaviour()
	if (Player.is_on_floor()):
		return Player.PS_IDLE
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		if ledge_behaviour != Globals.LEDGE_EXIT:
			init_arg_list.append(init_args.ENTER_ROLLING)
			return Player.PS_JUMPING #may change
		else:
			return Player.PS_WALLJUMPING
	if (ledge_behaviour != Globals.LEDGE_EXIT) && Player.velocity.y > 0 && Timers.get_node("PostClingJumpTimer").time_left == 0:
			return Player.PS_LEDGECLINGING
	if Player.wall_direction == get_input_direction() && Player.wall_direction != 0:
		return Player.PS_WALLSLIDING
	else:
		return Player.PS_FALLING

func set_cape_acceleration():
	Player.Cape.accel = Vector2(0, 8)
