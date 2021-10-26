extends PlayerState
var stop_rising = false
var rng = RandomNumberGenerator.new()

func enter(_init_arg):
	Animation_Player.play("jumping")
	Player.stop_jump_rise = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	print(self.name)
	Player.velocity.y = -JUMP_SPEED #jump
	play_jump_audio()

func do_state_logic(delta):
	do_attack()
	check_buffered_jump_input()
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.velocity.y > 0):
		return "falling"
	if (Player.is_on_floor()):
		return "idle"
	if can_wall_jump():
		if (Input.is_action_just_pressed("jump") or Player.isJumpBuffered):
			return "walljumping"
		else:
			return "wallsliding"
	return "jumping"



func play_jump_audio():
	Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.2, 0.9)
	Audio.get_node("JumpAudio").play(0.001) # Hide stupid audio artifact
