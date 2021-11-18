extends PlayerState

func _ready():
	is_dashing = true
	state_attack_type = Globals.DASH_ATTACK_DOWN

func set_player_sprite_direction():
	pass

func set_facing_direction():
	pass

func exit():
	stop_attack()
	return [init_args.ROLLING_FALL]

func set_attack_hitbox():
	Attack_Box.get_child(0).get_shape().extents = DASH_ATTACK_SIZE
	Attack_Box.position.y = -8
	Player.attack_box_x_distance = 11

func enter(_init_arg):
	force_attack()
	Timers.get_node("DashTimer").start(DASH_TIME)
	Timers.get_node("NoDashTimer").start(NO_DASH_TIME)
	Player.stop_jump_rise = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	print(self.name)
	Player.velocity.y = 150
	Player.velocity.x = set_if_lesser(Player.velocity.x, Player.facing * 180)

func do_state_logic(delta):
	check_buffered_jump_input()
	#do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, 0, ACCELERATE_WALK)
	
func check_buffered_inputs():
	check_buffered_jump_input()
	check_buffered_attack_input()
	check_buffered_redash_input()
	
func check_for_new_state() -> String:
	if (Player.is_on_floor()):
		if (Input.is_action_pressed("down")):
			return "ducking"
		else:
			return "rolling"
	if Timers.get_node("DashTimer").time_left > 0:
		return "dashing_down"
	return "falling"
