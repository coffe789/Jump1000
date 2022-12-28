extends "res://Content/Player/StateMachine/LedgeState.gd"


func _update(delta):
	._update(delta)
	Target.velocity.x += 4 * Target.facing
	Target.velocity.y = -10
	apply_velocity(true)
	Target.ledge_cast_lenient.force_raycast_update()
