extends PlayerState

func enter(_init_arg):
	Animation_Player.play("idle")

func do_state_logic(delta):
	do_attack()
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,FLOOR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (!Player.is_on_floor()):
		return "falling"
	if (Input.is_action_pressed("down") && Input.is_action_just_pressed("jump")) \
	or Input.is_action_pressed("down") && Player.isJumpBuffered:
		return "duckjumping"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "jumping"
	if Input.is_action_pressed("down"):
		return "ducking"
	if (get_input_direction()!=0):
		return "running"
	return "idle"
