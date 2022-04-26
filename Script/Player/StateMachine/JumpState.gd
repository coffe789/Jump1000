extends "res://Script/Player/StateMachine/AirState.gd"
var rng = RandomNumberGenerator.new()
var move_accel = ACCELERATE_WALK # Overriden in walljump

# Only use this for grounded jumps
func _choose_substate():
	if Input.is_action_pressed("down") || !Target.can_unduck:
		return $DuckJump
	if SM.is_spinning && get_input_direction() != 0:
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
	record_floor_velocity()
	set_dash_direction()
	do_attack()
	check_if_finish_jump()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, move_accel)


func emit_jump_particles(is_walljump=false):
	Target.get_node("Particles/JumpCloud").emitting = true
	if is_walljump:
		var mult = Target.wall_direction
		Target.get_node("Particles/JumpCloud").position.x = 4*mult
		Target.get_node("Particles/JumpCloud").process_material.direction.x = -mult
	else:
		Target.get_node("Particles/JumpCloud").position.x = 4*sign(-Target.velocity.x)
		Target.get_node("Particles/JumpCloud").process_material.direction.x = sign(-Target.velocity.x)
	yield(get_tree().create_timer(0.04), "timeout")
	Target.get_node("Particles/JumpCloud").emitting = false

func get_boost():
	record_floor_velocity()
	var mult = 0.5
	var boost = Vector2.ZERO
	var floor_v = Target.get_floor_velocity() # if frame perfect this fails TODO
	if floor_v.y == 0 && SM.last_ground_velocity.y < 0:
		boost.y = SM.last_ground_velocity.y * 3/5
	elif floor_v.y > 0:
		boost.y = -SM.last_ground_velocity.y
	else:
		boost.y = -SM.last_ground_velocity.y * 2/5
	boost.x = SM.last_ground_velocity.x * 3/5
	return boost

func _blacklist_transitions():
	remove_transition("to_ground")
