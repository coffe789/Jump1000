extends "res://Script/Player/StateMachine/GroundState.gd"

func _enter():
	Target.Animation_Player.play("running")

func _update(delta):
	._update(delta)
	Target.velocity = Target.move_and_slide_with_snap(Target.velocity,Vector2(0,2),UP_DIRECTION)
