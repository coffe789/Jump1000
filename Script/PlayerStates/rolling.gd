extends PlayerState
var roll_direction

func enter(_init_arg):
	roll_direction = Player.facing
	print(self.name)

func do_state_logic(delta):
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_unconcontrolled_movement(delta, 100 * roll_direction, 10)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (!Player.is_on_floor()):
		return "falling"
	if (Input.is_action_pressed("down") && Input.is_action_just_pressed("jump")) \
	or Input.is_action_pressed("down") && Player.isJumpBuffered:
		return "duckjumping"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		Player.velocity.x += roll_direction*100
		return "jumping"
	if Input.is_action_pressed("down"):
		return "ducking"
	if (get_input_direction()==roll_direction*-1):
		return "running"
	return "rolling"
