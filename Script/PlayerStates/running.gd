extends PlayerState

func do_state_logic(delta):
	do_attack()
	Animation_Player.play("running")
	start_coyote_time()
	Player.velocity.y = 0
	do_normal_x_movement(delta,FLOOR_DRAG, ACCELERATE_WALK)
	Player.velocity.y = 10
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Input.is_action_pressed("down") && Input.is_action_just_pressed("jump"))\
	or (Input.is_action_pressed("down") && Player.isJumpBuffered):
		return Player.PS_DUCKJUMPING
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return Player.PS_JUMPING
	if (!Player.is_on_floor()):
		return Player.PS_FALLING
	if (Input.is_action_pressed("down")):
		return Player.PS_DUCKING
	if (get_input_direction()==0):
		return Player.PS_IDLE
	if can_wall_jump() and not Player.is_on_floor():
		if (Input.is_action_just_pressed("jump") or Player.isJumpBuffered):
			return Player.PS_WALLJUMPING
		else:
			return Player.PS_WALLSLIDING
	return Player.PS_RUNNING

