extends PlayerState

func _ready():
	is_dashing = true

func set_player_sprite_direction():
	pass

func set_facing_direction():
	pass

func enter(_init_arg):
	Timers.get_node("DashTimer").start(0.2)
	Player.stop_jump_rise = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	print(self.name)
	Player.velocity = Vector2(Player.facing * 200, -200)

func do_state_logic(delta):
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, AIR_DRAG, ACCELERATE_WALK)
	
func check_for_new_state() -> String:
	if Timers.get_node("DashTimer").time_left > 0:
		return "dashing_up"
	return "falling"
