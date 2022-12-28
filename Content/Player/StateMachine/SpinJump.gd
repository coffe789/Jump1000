extends "res://Content/Player/StateMachine/JumpState.gd"

func _enter():
	._enter()
	SM.is_spinning = true
	Target.Animation_Player.play("rolling")
	if get_input_direction()==0:
		Target.velocity.x = set_if_lesser(-Target.velocity.x, -Target.facing * 100)
	elif get_input_direction() == -Target.wall_direction:
		Target.velocity.x = set_if_lesser(-Target.velocity.x, -Target.facing * WALLJUMP_X_SPEED_MULTIPLIER * MAX_X_SPEED)
	Target.velocity.y = -JUMP_SPEED
	record_wall_velocity(Target.facing)
	Target.velocity += SM.last_wall_velocity
	if Target.ledge_cast_height_search.get_collider() && "velocity" in Target.ledge_cast_height_search.get_collider():
		Target.velocity.y += Target.ledge_cast_height_search.get_collider().velocity.y
		#print(Target.ledge_cast_height_search.get_collider().velocity.y)
	play_jump_audio()
	emit_jump_particles(true)

func _update(delta):
	._update(delta)
	set_dash_target()
	apply_velocity(true)

func _exit():
	SM.is_spinning = false
