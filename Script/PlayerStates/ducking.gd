extends PlayerState

func set_attack_hitbox():
	Attack_Box.get_child(0).get_shape().extents = NORMAL_ATTACK_SIZE
	Attack_Box.position.y = -5
	Player.attack_box_x_distance = 11

func enter(init_arg):
	set_y_collision(DUCKING_COLLISION_EXTENT,-4)
	
	if init_arg != null:
		if !init_arg.has(init_args.FROM_DUCKING):
			Animation_Player.play("ducking")
	else:
		Animation_Player.play("ducking")
		

func do_state_logic(delta):
	do_attack()
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, DUCK_FLOOR_DRAG, 0)

func check_for_new_state() -> String:
	if (!Player.is_on_floor()):
		return Player.PS_DUCKFALLING
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return Player.PS_DUCKJUMPING
	if (!Input.is_action_pressed("down") && Player.can_unduck):
		return Player.PS_IDLE
	return Player.PS_DUCKING

func exit():
	set_y_collision(NORMAL_COLLISION_EXTENT,-8)
	Collision_Body.get_shape().extents = NORMAL_COLLISION_EXTENT
	
	init_arg_list.append(init_args.FROM_DUCKING)
	return init_arg_list
