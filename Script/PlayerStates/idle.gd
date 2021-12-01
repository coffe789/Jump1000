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
		return Player.PS_FALLING
	if (Input.is_action_pressed("down") && Input.is_action_just_pressed("jump")) \
	or Input.is_action_pressed("down") && Player.isJumpBuffered:
		return Player.PS_DUCKJUMPING
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return Player.PS_JUMPING
	if Input.is_action_pressed("down"):
		return Player.PS_DUCKING
	if (get_input_direction()!=0):
		return Player.PS_RUNNING
	return Player.PS_IDLE
