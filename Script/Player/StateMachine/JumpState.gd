extends "res://Script/Player/StateMachine/RootState.gd"
var rng = RandomNumberGenerator.new()
var move_accel = ACCELERATE_WALK # Overriden in walljump

# TODO extend
func _choose_substate():
	return $NormalJump

func play_jump_audio():
	Target.Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.2, 0.9)
	Target.Audio.get_node("JumpAudio").play(0.001) # Hide stupid audio artifact

func play_walljump_audio():
	Target.Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.5, 1.2)
	Target.Audio.get_node("JumpAudio").play(0.001) # Hide very cool audio artifact

func _enter():
	Player.stop_jump_rise = false
	Player.isJumpBuffered = false
	Player.canCoyoteJump = false
	emit_jump_particles()

func _update(delta):
	set_dash_direction()
	do_attack()
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, move_accel)
