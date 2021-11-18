extends PlayerState

func _ready():
	is_dashing = true
	state_attack_type = Globals.DASH_ATTACK_UP

func set_player_sprite_direction():
	pass

func set_facing_direction():
	pass

func exit():
	stop_attack()

func check_buffered_inputs():
	check_buffered_jump_input()
	check_buffered_attack_input()
	check_buffered_redash_input()

func set_attack_hitbox():
	Attack_Box.get_child(0).get_shape().extents = DASH_ATTACK_SIZE
	Attack_Box.position.y = -8
	Player.attack_box_x_distance = 11

func enter(_init_arg):
	force_attack()
	Timers.get_node("DashTimer").start(DASH_TIME)
	Timers.get_node("WallBounceTimer").start(0.8)
	Timers.get_node("NoDashTimer").start(NO_DASH_TIME)
	Player.stop_jump_rise = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	print(self.name)
	Player.velocity.x = set_if_lesser(Player.velocity.x, Player.facing * DASH_SPEED_X)
	Player.velocity.y = -DASH_SPEED_Y

func do_state_logic(delta):
	check_buffered_jump_input()
	#do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, 0, ACCELERATE_WALK)
	
func check_for_new_state() -> String:
	if can_wall_jump():
		if (Input.is_action_just_pressed("jump") or Player.isJumpBuffered):
			if Timers.get_node("WallBounceTimer").time_left > 0 && Player.velocity.y < 0:
				return "wallbouncing"
			else:
				return "walljumping"
	if Timers.get_node("DashTimer").time_left > 0:
		return "dashing_up"
	return "falling"
