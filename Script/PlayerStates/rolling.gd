extends PlayerState
var roll_direction

func enter(_init_arg):
	Animation_Player.play("rolling")
	roll_direction = get_input_direction()
	Timers.get_node("RollTimer").start(ROLL_TIME)

func do_state_logic(delta):
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_unconcontrolled_movement(delta, MAX_X_SPEED * roll_direction, 1000)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (!Player.is_on_floor()):
		init_arg_list.append(init_args.ENTER_ROLLING)
		return Player.PS_FALLING
	if (Input.is_action_pressed("down") && Input.is_action_just_pressed("jump")) \
	or Input.is_action_pressed("down") && Player.isJumpBuffered:
		return Player.PS_DUCKJUMPING
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		init_arg_list.append(init_args.ENTER_SUPER_JUMP)
		return Player.PS_JUMPING
	if Input.is_action_pressed("down"):
		return Player.PS_DUCKING
	if (get_input_direction()==roll_direction*-1 || get_input_direction() == 0):
		return Player.PS_RUNNING
	if (Player.velocity.x == 0): #hit a wall
		return Player.PS_IDLE
	if Timers.get_node("RollTimer").time_left == 0:
		return Player.PS_IDLE
	return Player.PS_ROLLING
