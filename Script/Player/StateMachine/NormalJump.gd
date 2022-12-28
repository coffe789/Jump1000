extends "res://Script/Player/StateMachine/JumpState.gd"

func _enter():
	._enter()
	Target.velocity.y = -JUMP_SPEED
	Target.velocity += get_boost()
	play_jump_audio()
	Target.Animation_Player.conditional_play("jumping")
	emit_jump_particles()

func _update(delta):
	._update(delta)
	set_dash_target()
	apply_velocity(true)
