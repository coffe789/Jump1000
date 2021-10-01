extends PlayerState


func enter(_init_arg):
	print(self.name)
	Player.acceleration.y -= JUMP_ACCELERATION
	play_jump_audio()

# If you let go of jump, stop going up. Also handles buffered case.
func check_if_finish_jump() -> void:
	if ((Input.is_action_just_released("jump") && Player.acceleration.y < 0)):
	#or (justJumpBuffered && !Input.is_action_pressed("jump")):
		Player.acceleration.y /= AFTER_JUMP_DECELERATION_FACTOR;

func do_state_logic(_delta):
	if (Player.is_on_ceiling()):
		Player.acceleration.y = 0
	apply_directional_input()
	Player.acceleration.y += GRAVITY
	apply_drag()
	check_if_finish_jump()
	clamp_movement()
	Player.velocity += Player.acceleration
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.velocity.y > 0):
		return "falling"
	if (Player.is_on_floor()):
		return "idle"
	return "jumping"

func play_jump_audio():
	Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.2, 0.9)
	Audio.get_node("JumpAudio").play(0.001)
