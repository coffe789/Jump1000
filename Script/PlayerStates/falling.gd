extends PlayerState
var is_rolling_fall = false

func _ready():
	unset_dash_target = false

func enter(init_arg):
	Animation_Player.play("falling")
	if init_arg != null:
		if init_arg.has(init_args.ROLLING_FALL):
			is_rolling_fall = true

func exit():
	is_rolling_fall = false

func do_state_logic(delta):
	set_dash_target()
	set_dash_direction()
	do_attack()
	#check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.is_on_floor()):
		if is_rolling_fall:
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
			else:
				return "walljumping"
		elif Timers.get_node("WallBounceTimer").time_left > 0 && Player.velocity.y < 0:
			return "wallbounce_sliding"
		elif Player.wall_direction == get_input_direction() && Player.wall_direction != 0:
			return "wallsliding"
	if (Player.dash_direction == -1 && Input.is_action_just_pressed("attack")) || Timers.get_node("BufferedRedashTimer").time_left > 0:
		return "dashing_up"
	if (Player.dash_direction == 1 && Input.is_action_just_pressed("attack")) || Timers.get_node("BufferedRedashTimer").time_left > 0:
		return "dashing_down"
	return "falling"
