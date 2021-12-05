extends PlayerState
var stop_rising = false
var rng = RandomNumberGenerator.new()

func _ready():
	unset_dash_target = false

func enter(_init_arg):
	Player.stop_jump_rise = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	#Player.velocity.y = -JUMP_SPEED #jump
	Player.velocity.y = -JUMP_SPEED
	Player.velocity.x = MAX_X_SPEED*(-Player.wall_direction) * WALLJUMP_X_SPEED_MULTIPLIER
	play_jump_audio()
	emit_jump_particles()

func do_state_logic(delta):
	set_dash_target()
	set_dash_direction()
	do_attack()
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK * WALLJUMP_SLOWDOWN_MULTIPLIER)
	Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)
	
func check_for_new_state() -> String:
	return get_parent().get_node("jumping").check_for_new_state()

func play_jump_audio():
	Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.5, 1.2)
	Audio.get_node("JumpAudio").play(0.001) # Hide very cool audio artifact
