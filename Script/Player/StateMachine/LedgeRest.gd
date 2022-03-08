extends "res://Script/Player/StateMachine/LedgeState.gd"


func _update(delta):
	if get_ledge_Y()-Target.ledge_cast_top.global_position.y < 0:
		if Target.ledge_cast_height_search.get_collider() && "velocity" in Target.ledge_cast_height_search.get_collider():
#			Target.velocity.y = Target.ledge_cast_height_search.get_collider().velocity.y
			Target.global_position.y = get_ledge_Y()+12
			Target.velocity = Target.ledge_cast_height_search.get_collider().velocity
		else:
			Target.velocity.y = 0
		Target.velocity.x += 4 * Target.facing
		Target.velocity.x = Target.move_and_slide(Target.velocity, UP_DIRECTION).x
		report_ledge_collision()
	else:
		do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
		Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
