extends "res://Script/Player/StateMachine/JumpState.gd"

func _enter():
	._enter()
	Target.velocity.y = -JUMP_SPEED - Target.get_floor_velocity().y
	play_jump_audio()
	Target.Animation_Player.play("jumping")
	emit_jump_particles()

func _update(delta):
	._update(delta)
	set_dash_target()
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
