extends "res://Script/Player/StateMachine/FallState.gd"

func _enter():
	Target.Animation_Player.play("rolling")

func _update(delta):
	get_parent()._udpate(delta)
	set_dash_target()
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
