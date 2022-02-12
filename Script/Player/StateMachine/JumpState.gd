extends "res://Script/Player/StateMachine/AirState.gd"
var rng = RandomNumberGenerator.new()
var move_accel = ACCELERATE_WALK # Overriden in walljump

# Only use this for grounded jumps
func _choose_substate():
	if Input.is_action_pressed("down"):
		return $DuckJump
	if Target.is_spinning:
		return $SuperJump
	return $NormalJump

func play_jump_audio():
	Target.Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.2, 0.9)
	Target.Audio.get_node("JumpAudio").play(0.001) # Hide stupid audio artifact

func play_walljump_audio():
	Target.Audio.get_node("JumpAudio").pitch_scale = rng.randf_range(1.5, 1.2)
	Target.Audio.get_node("JumpAudio").play(0.001) # Hide very cool audio artifact

func _enter():
	Target.stop_jump_rise = false
	Target.isJumpBuffered = false
	Target.canCoyoteJump = false

func _update(delta):
	set_dash_direction()
	do_attack()
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, move_accel)

func _add_transitions():
	._add_transitions()
	transitions.append(StateTransition.new(
		-10,"to_fallstate",SM.get_node("RootState/AirState/FallState"),funcref(conditions_lib,"is_falling")))
