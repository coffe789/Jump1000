extends PlayerState
var stop_rising = false
var rng = RandomNumberGenerator.new()

func enter(_init_arg):
	stop_rising = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	print(self.name)
	Player.velocity.y = -JUMP_SPEED #jump
	Player.velocity.x = MAX_X_SPEED*(-Player.facing)*1.25
	play_jump_audio()

func do_state_logic(delta):
	check_buffered_jump_input()
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG)
	Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)
	
func check_for_new_state() -> String:
	if (Player.velocity.y > 0):
		return "falling"
	if (Player.is_on_floor()):
		return "idle"
	if ((Input.is_action_just_pressed("jump") || Player.isJumpBuffered) && Player.can_wall_jump()):
		return "walljumping"
	return "walljumping"

# If you let go of jump, stop going up. Also handles buffered case.
func check_if_finish_jump() -> void:
	if ((!Input.is_action_pressed("jump") && !stop_rising)):
		Player.velocity.y /= AFTER_JUMP_SLOWDOWN_FACTOR;
		stop_rising = true;

func play_jump_audio():
	Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.5, 1.2)
	Audio.get_node("JumpAudio").play(0.001) # Hide very cool audio artifact
