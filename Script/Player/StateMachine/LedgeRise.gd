extends "res://Script/Player/StateMachine/LedgeState.gd"


func _update(delta):
	._update(delta)
	Target.velocity.x += 4 * Target.facing
	Target.velocity.y = -10
	Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
	Target.ledge_cast_lenient.force_raycast_update()
