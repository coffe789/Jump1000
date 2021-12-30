extends PlayerState
var stop_rising = false
var rng = RandomNumberGenerator.new()

func _ready():
	unset_dash_target = false

func enter(_init_arg):
	Animation_Player.play("rolling")
	stop_rising = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	Player.velocity.y = -JUMP_SPEED * WALLBOUNCE_MULTIPLIER
	Player.velocity.x = MAX_X_SPEED*(-Player.last_wall_direction) * WALLJUMP_X_SPEED_MULTIPLIER
	play_jump_audio()
	emit_jump_particles()

func do_state_logic(delta):
	set_dash_target()
	set_dash_direction()
	do_attack()
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK * WALLJUMP_SLOWDOWN_MULTIPLIER * 1.2)
	Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)
	
func check_for_new_state() -> String:
	if (Player.velocity.y > 0):
		return Player.PS_FALLING
	if (Player.is_on_floor()):
		return Player.PS_IDLE
	if can_wall_jump():
		if (Input.is_action_just_pressed("jump") or Player.isJumpBuffered):
			return Player.PS_WALLJUMPING
	if Player.dash_direction == -1 && Input.is_action_just_pressed("attack"):
		return Player.PS_DASHING_UP
	if Player.dash_direction == 1 && Input.is_action_just_pressed("attack"):
		return Player.PS_DASHING_DOWN
	return Player.PS_WALLBOUNCING

# If you let go of jump, stop going up. Also handles buffered case.
func check_if_finish_jump() -> void:
	if ((!Input.is_action_pressed("jump") && !stop_rising)):
		Player.velocity.y /= AFTER_JUMP_SLOWDOWN_FACTOR;
		stop_rising = true;

func play_jump_audio():
	Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.5, 1.2)
	Audio.get_node("JumpAudio").play(0.001) # Hide very cool audio artifact
