extends PlayerState
var is_rolling_fall = false

func _ready():
	unset_dash_target = false

func enter(init_arg):
	Animation_Player.play("falling")
	if init_arg != null:
		if init_arg.has(init_args.ROLLING_FALL):
			is_rolling_fall = true

var is_exit_roll_jump = false
func exit():
	is_rolling_fall = false
	if is_exit_roll_jump:
		is_exit_roll_jump = false
		return [init_args.ROLLING_JUMP]

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
			return "rolling"
		if (Input.is_action_pressed("left") || Input.is_action_pressed("right")):
			return "running"
		if (Input.is_action_pressed("down")):
			return "ducking"
		else:
			return "idle"
	if (Input.is_action_just_pressed("jump") && Player.canCoyoteJump):
		return "jumping"
	if can_wall_jump():
		if (Input.is_action_just_pressed("jump") or Player.isJumpBuffered):
			if Timers.get_node("WallBounceTimer").time_left > 0 && Player.velocity.y < 0:
				return "wallbouncing"
			elif (get_ledge_behaviour() != Globals.LEDGE_EXIT) && can_wall_jump():
				Timers.get_node("PostClingJumpTimer").start(0.12)
				is_exit_roll_jump = true
				return "jumping"#will maybe change later?
			else:
				return "walljumping"
		elif Timers.get_node("WallBounceTimer").time_left > 0 && Player.velocity.y < 0:
			return "wallbounce_sliding"
		elif (get_ledge_behaviour() != Globals.LEDGE_EXIT):
			return "ledgeclinging"
		elif Player.wall_direction == get_input_direction() && Player.wall_direction != 0:
			return "wallsliding"
	if (Input.is_action_just_pressed("attack") || Timers.get_node("BufferedRedashTimer").time_left > 0 || Timers.get_node("BufferedDashTimer").time_left > 0) && Timers.get_node("NoDashTimer").time_left == 0:
		if Player.dash_direction == -1:
			return "dashing_up"
		if Player.dash_direction == 1:
			return "dashing_down"
	return "falling"
