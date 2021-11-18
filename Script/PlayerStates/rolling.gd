extends PlayerState
var roll_direction

func enter(_init_arg):
	if get_input_direction() == 0:
		roll_direction = Player.facing
	else:
		roll_direction = get_input_direction()
	Timers.get_node("RollTimer").start(ROLL_TIME)
	print(self.name)

func do_state_logic(delta):
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_unconcontrolled_movement(delta, MAX_X_SPEED * roll_direction, 1000)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (!Player.is_on_floor()):
		return "falling"
	if (Input.is_action_pressed("down") && Input.is_action_just_pressed("jump")) \
	or Input.is_action_pressed("down") && Player.isJumpBuffered:
		return "duckjumping"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		Player.velocity.x = set_if_lesser(Player.velocity.x, roll_direction*260)
		return "jumping"
	if Input.is_action_pressed("down"):
		return "ducking"
	if (get_input_direction()==roll_direction*-1 || get_input_direction() == 0):
		return "running"
	if (Player.velocity.x == 0): #hit a wall
		return "idle"
	if Timers.get_node("RollTimer").time_left == 0:
		return "idle"
	return "rolling"
