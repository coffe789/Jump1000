extends "res://Script/Player/StateMachine/LedgeState.gd"

func _update(_delta):
#	report_ledge_collision()
	Target.velocity.x += 4 * Target.facing
	Target.velocity.y = -10
	Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
