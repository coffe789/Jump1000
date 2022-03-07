extends "res://Script/Player/StateMachine/GroundState.gd"

func _enter():
	Target.Animation_Player.play("idle")

func _update(delta):
	._update(delta)
	Target.velocity = Target.move_and_slide_with_snap(Target.velocity,Vector2.DOWN * 3, Vector2.UP)
