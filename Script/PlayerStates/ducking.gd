extends PlayerState

func set_attack_hitbox():
	Attack_Box.get_child(0).get_shape().extents = Vector2(8,5)
	Attack_Box.position.y = -5
	Player.attack_box_x_distance = 14

func enter(_init_arg):
	Collision_Body.get_shape().extents = DUCKING_COLLISION_EXTENT
	Collision_Body.position.y = -4
	Animation_Player.play("ducking")
	print(self.name)

func do_state_logic(delta):
	do_attack()
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, DUCK_FLOOR_DRAG, 0)

func check_for_new_state() -> String:
	if (!Player.is_on_floor()):
		return "duckfalling"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "duckjumping"
	if (!Input.is_action_pressed("down") && Player.can_unduck):
		return "idle"
	return "ducking"

func exit():
	Collision_Body.get_shape().extents = NORMAL_COLLISION_EXTENT
	Collision_Body.position.y = -8
