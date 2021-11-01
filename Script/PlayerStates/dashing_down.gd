extends PlayerState

func _ready():
	is_dashing = true

func set_player_sprite_direction():
	pass

func set_facing_direction():
	pass

func enter(_init_arg):
	Timers.get_node("DashTimer").start(0.5)
	Player.stop_jump_rise = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	print(self.name)
	Player.velocity = Vector2(Player.facing * 200, 140)

func do_state_logic(delta):
	check_buffered_jump_input()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, AIR_DRAG, ACCELERATE_WALK)
	
func check_for_new_state() -> String:
	if (Player.is_on_floor()):
#		if (Input.is_action_pressed("left") || Input.is_action_pressed("right")):
#			return "running"
		if (Input.is_action_pressed("down")):
			return "ducking"
		else:
			return "rolling"
	if Timers.get_node("DashTimer").time_left > 0:
		return "dashing_down"
	return "falling"
