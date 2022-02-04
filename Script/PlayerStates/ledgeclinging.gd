extends PlayerState
var ledge_behaviour


func do_state_transition():
	pass


# Makes sure the player always rests at the same height
# Method desparately needs optimisation lol
func get_ledge_Y():
	for i in 7: #(-5--12)
		ledge_cast_top.position.y += 1
		ledge_cast_top.force_raycast_update()
		if _check_is_valid_wall(ledge_cast_top):
			var ledge_pos = ledge_cast_top.global_position.y
			ledge_cast_top.position.y = -12 # Initial value
			return ledge_pos


func do_state_logic(delta):
	check_if_finish_jump()
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
		if ledge_behaviour == Globals.LEDGE_LENIENCY_RISE:
			Player.velocity.y = -10
		do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
		Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)


func set_cape_acceleration():
	Player.Cape.accel = Vector2(0, 8)


func check_for_new_state() -> String:
	_update_wall_direction()
	if (Player.is_on_floor()):
		return Player.PS_IDLE
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		Timers.get_node("PostClingJumpTimer").start(0.12)
		init_arg_list.append(init_args.ENTER_ROLLING)
		return Player.PS_JUMPING
	if ledge_behaviour == Globals.LEDGE_EXIT:
#		if Player.velocity.y < 10:
#			return Player.PS_PREVIOUS
#		else:
			return Player.PS_FALLING
	else:
		return Player.PS_LEDGECLINGING
