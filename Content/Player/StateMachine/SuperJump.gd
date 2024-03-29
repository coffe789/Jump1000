extends "res://Content/Player/StateMachine/JumpState.gd"

func _enter():
	._enter()
	play_jump_audio()
	Target.velocity.y = -JUMP_SPEED
	Target.velocity += get_boost()
	Target.Animation_Player.conditional_play("jumping")
	var dir = Target.facing if get_input_direction()==0 else get_input_direction()
	Target.velocity.x = set_if_lesser(Target.velocity.x, dir*230)
	emit_jump_particles()

func _update(delta):
	._update(delta)
	set_dash_target()
	apply_velocity(true)
