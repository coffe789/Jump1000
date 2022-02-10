extends "res://Script/Player/StateMachine/JumpState.gd"

func _enter():
	get_parent()._enter()
	Target.velocity.y = -JUMP_SPEED
	play_jump_audio()
	Target.Animation_Player.play("jumping")

func _update(delta):
	get_parent()._update(delta)
	set_dash_target()
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
