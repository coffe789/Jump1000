extends PlayerState
var stop_rising = false
var rng = RandomNumberGenerator.new()
var can_roll_fall = false

func _ready():
	unset_dash_target = false

func enter(init_arg):
	Animation_Player.play("jumping")
	Player.stop_jump_rise = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	Player.velocity.y = -JUMP_SPEED #jump
	play_jump_audio()
	if init_arg != null:
		if init_arg.has(init_args.ROLLING_JUMP):
			can_roll_fall = true
	emit_jump_particles()

var is_exit_roll_jump = false
func exit():
	var to_return = []
	if can_roll_fall:
		can_roll_fall = false
		to_return.append(init_args.ROLLING_FALL)
	if is_exit_roll_jump:
		is_exit_roll_jump = false
		to_return.append(init_args.ROLLING_JUMP)
	return to_return

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
	if (Player.velocity.y > 0):
		return Player.PS_FALLING
	if (Player.is_on_floor()):
		return Player.PS_IDLE
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered)\
	and ledge_behaviour != Globals.LEDGE_EXIT && can_wall_jump():
		get_parent().get_node("ledgeclinging").exit()
		is_exit_roll_jump = true
		return Player.PS_JUMPING #may change
	if (ledge_behaviour != Globals.LEDGE_EXIT) && Timers.get_node("PostClingJumpTimer").time_left == 0:
		return Player.PS_LEDGECLINGING
	if can_wall_jump():
		if (Input.is_action_just_pressed("jump") or Player.isJumpBuffered):
			return Player.PS_WALLJUMPING
#		elif get_input_direction() == Player.wall_direction && Timers.get_node("PostClingJumpTimer").time_left == 0:
#			return Player.PS_WALLSLIDING
	if Player.dash_direction == -1 && (Input.is_action_just_pressed("attack") || Timers.get_node("BufferedDashTimer").time_left > 0):
		return Player.PS_DASHING_UP
	if Player.dash_direction == 1 && (Input.is_action_just_pressed("attack") || Timers.get_node("BufferedDashTimer").time_left > 0):
		return Player.PS_DASHING_DOWN
	return Player.current_state

func check_buffered_inputs():
	check_buffered_jump_input()
	check_buffered_attack_input()
	check_buffered_dash_input()

func play_jump_audio():
	Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.2, 0.9)
	Audio.get_node("JumpAudio").play(0.001) # Hide stupid audio artifact
