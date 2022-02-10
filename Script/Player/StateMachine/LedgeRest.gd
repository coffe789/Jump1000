extends "res://Script/Player/StateMachine/LedgeState.gd"

#TODO this has changed, make sure it works
func _update(_delta):
	Target.velocity.y = 0
	Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
