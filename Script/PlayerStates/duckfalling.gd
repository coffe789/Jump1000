extends PlayerState

func set_attack_hitbox():
	$"../ducking".set_attack_hitbox()

func do_state_logic(delta):
	do_attack()
	Animation_Player.play("ducking")
	Collision_Body.get_shape().extents = DUCKING_COLLISION_EXTENT
	Collision_Body.position.y = -4
	check_buffered_jump_input()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.is_on_floor()):
		if (Input.is_action_pressed("down") || !Player.can_unduck):
			return Player.PS_DUCKING
		if (Input.is_action_pressed("left") || Input.is_action_pressed("right")):
			return Player.PS_RUNNING
		else:
			return Player.PS_IDLE
	return Player.PS_DUCKFALLING

func exit():
	Collision_Body.get_shape().extents = NORMAL_COLLISION_EXTENT
	Collision_Body.position.y = -8
