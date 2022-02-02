extends PlayerState
var stop_rising = false
var rng = RandomNumberGenerator.new()
var can_roll_fall = false

func _ready():
	unset_dash_target = false

func enter(init_arg):
	Player.stop_jump_rise = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	Player.velocity.y = -JUMP_SPEED #jump
	play_jump_audio()
	Animation_Player.play("jumping")
	
	if init_arg.has(init_args.ENTER_SUPER_JUMP):
		Player.velocity.x = \
			set_if_lesser(Player.velocity.x, get_node("../rolling").roll_direction*260)
	if init_arg.has(init_args.ENTER_ROLLING):
		Timers.get_node("PostClingJumpTimer").start(0.12)
		Animation_Player.play("rolling")
		Animation_Player.queue("jumping")
		can_roll_fall = true
	emit_jump_particles()

func exit():
	if can_roll_fall:
		can_roll_fall = false
		init_arg_list.append(init_args.ENTER_ROLLING)
	return init_arg_list

func do_state_logic(delta):
	set_dash_target()
	set_dash_direction()
	if do_attack():
		can_roll_fall = false #cancel rolling upon attack
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	var ledge_behaviour = get_ledge_behaviour()
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered)\
	and ledge_behaviour != Globals.LEDGE_EXIT && can_wall_jump() && Player.velocity.y <= 0:
		Timers.get_node("PostClingJumpTimer").start(0.12)
		exit()
		init_arg_list.append(init_args.ENTER_ROLLING)
		enter(init_arg_list)
		return Player.PS_JUMPING #may change
	if (ledge_behaviour != Globals.LEDGE_EXIT) && Timers.get_node("PostClingJumpTimer").time_left == 0 and Player.velocity.y > 0:
		return Player.PS_LEDGECLINGING
	if can_wall_jump():
		if (Input.is_action_just_pressed("jump") or Player.isJumpBuffered):
			get_parent().get_node("walljumping").enter([]) # If it ain't broke
			return Player.PS_WALLJUMPING
#		elif get_input_direction() == Player.wall_direction && Timers.get_node("PostClingJumpTimer").time_left == 0:
#			return Player.PS_WALLSLIDING
	if Player.dash_direction == -1 && (Input.is_action_just_pressed("attack") || Timers.get_node("BufferedDashTimer").time_left > 0):
		return Player.PS_DASHING_UP
	if Player.dash_direction == 1 && (Input.is_action_just_pressed("attack") || Timers.get_node("BufferedDashTimer").time_left > 0):
		return Player.PS_DASHING_DOWN
	if (Player.velocity.y > 0):
		return Player.PS_FALLING
#	if (Player.is_on_floor()):
#		print("here")
#		return Player.PS_IDLE
	return Player.current_state

func check_buffered_inputs():
	check_buffered_jump_input()
	check_buffered_attack_input()
	check_buffered_dash_input()

func play_jump_audio():
	Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.2, 0.9)
	Audio.get_node("JumpAudio").play(0.001) # Hide stupid audio artifact
