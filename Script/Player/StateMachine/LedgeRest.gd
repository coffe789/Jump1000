extends "res://Script/Player/StateMachine/LedgeState.gd"


func _update(delta):
	if get_ledge_Y()-Target.ledge_cast_top.global_position.y < 0:
		print("here")
		Target.velocity.y = 0
		Target.velocity.x += 4 * Target.facing
		Target.velocity.x = Target.move_and_slide(Target.velocity, UP_DIRECTION).x
	else:
		do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
		Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
