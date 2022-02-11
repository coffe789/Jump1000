extends "res://Script/Player/StateMachine/GroundState.gd"

func _enter():
	Target.Animation_Player.play("running")

func _update(delta):
	._update(delta)
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
