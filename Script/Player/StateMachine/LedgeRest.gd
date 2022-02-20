extends "res://Script/Player/StateMachine/LedgeState.gd"


func _update(delta):
	if get_ledge_Y()-Target.ledge_cast_top.global_position.y < 0:
		Target.velocity.y = 0
		Target.velocity.x += 2 * Target.facing
		Target.velocity.x = Target.move_and_slide(Target.velocity, UP_DIRECTION).x
	else:
		do_gravity(delta, MAX_FALL_SPEED, GRAVITY * 1.5)
		Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
