extends PlayerState
var is_rolling_fall = false

func _ready():
	unset_dash_target = false

func enter(init_arg):
	Animation_Player.play("floating")
	Animation_Player.queue("falling")
	if init_arg != null:
		if init_arg.has(init_args.ENTER_ROLLING):
			is_rolling_fall = true
			Animation_Player.play("rolling")

func exit():
	is_rolling_fall = false
	
	return init_arg_list

func do_state_logic(delta):
	set_dash_target()
	set_dash_direction()
	if do_attack(): #cancel rolling fall if you attack
		is_rolling_fall = false
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_buffered_inputs():
	check_buffered_jump_input()
	check_buffered_attack_input()
	if Timers.get_node("NoDashTimer").time_left > 0:
		check_buffered_redash_input()

func check_for_new_state() -> String:
	if (Player.is_on_floor()):
		if is_rolling_fall && get_input_direction() != 0:
			return Player.PS_ROLLING
		if (Input.is_action_pressed("down")):
			return Player.PS_DUCKING
		if (Input.is_action_pressed("left") || Input.is_action_pressed("right")):
			return Player.PS_RUNNING
		else:
			return Player.PS_IDLE
	if (Input.is_action_just_pressed("jump") && Player.canCoyoteJump):
		if is_rolling_fall:
			init_arg_list.append(init_args.ENTER_SUPER_JUMP)
		return Player.PS_JUMPING
	if can_wall_jump():
		if (Input.is_action_just_pressed("jump") or Player.isJumpBuffered):
			if Timers.get_node("WallBounceTimer").time_left > 0 && Player.velocity.y < 0:
				return Player.PS_WALLBOUNCING
			elif (get_ledge_behaviour() != Globals.LEDGE_EXIT) && can_wall_jump():
				Timers.get_node("PostClingJumpTimer").start(0.12)
				init_arg_list.append(init_args.ENTER_ROLLING)
				return Player.PS_JUMPING#will maybe change later?
			else:
				return Player.PS_WALLJUMPING
		elif Timers.get_node("WallBounceTimer").time_left > 0 && Player.velocity.y < 0:
			return Player.PS_WALLBOUNCE_SLIDING
		elif (get_ledge_behaviour() != Globals.LEDGE_EXIT && Player.velocity.y <= 0):
			return Player.PS_LEDGECLINGING
		elif Player.wall_direction == get_input_direction() && Player.wall_direction != 0 && Player.directionY < 0:
			return Player.PS_WALLSLIDING
	if (Input.is_action_just_pressed("attack") || Timers.get_node("BufferedRedashTimer").time_left > 0 || Timers.get_node("BufferedDashTimer").time_left > 0) && Timers.get_node("NoDashTimer").time_left == 0:
		if Player.dash_direction == -1:
			return Player.PS_DASHING_UP
		if Player.dash_direction == 1:
			return Player.PS_DASHING_DOWN
	return Player.PS_FALLING
