extends PlayerState

var stop_rising = false
var rng = RandomNumberGenerator.new()

func enter(_init_arg):
	Collision_Body.get_shape().extents = DUCKING_COLLISION_EXTENT
	Collision_Body.position.y = -4
	Animation_Player.play("ducking")
	stop_rising = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	print(self.name)
	Player.velocity.y = -JUMP_SPEED #jump
	play_jump_audio()

func do_state_logic(delta):
	check_buffered_jump_input()
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.velocity.y > 0):
		return "duckfalling"
	if (Player.is_on_floor()):
		if Player.can_unduck:
			return "idle"
		else:
			return "ducking"
	return "duckjumping"

# If you let go of jump, stop going up. Also handles buffered case.
func check_if_finish_jump() -> void:
	if ((!Input.is_action_pressed("jump") && !stop_rising)):
		Player.velocity.y /= AFTER_JUMP_SLOWDOWN_FACTOR;
		stop_rising = true;

func play_jump_audio():
	Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.2, 0.9)
	Audio.get_node("JumpAudio").play(0.001) # Hide stupid audio artifact

func exit():
	Collision_Body.get_shape().extents = NORMAL_COLLISION_EXTENT
	Collision_Body.position.y = -8

func set_attack_hitbox():
	$"../ducking".set_attack_hitbox()
