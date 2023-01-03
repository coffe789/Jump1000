extends "res://Content/Player/StateMachine/LedgeState.gd"

func _update(delta):
	._update(delta)
	if get_ledge_Y()-Target.ledge_cast_top.global_position.y < 0 and Target.ledge_cast_height_search.is_colliding():
		if Target.ledge_cast_height_search.get_collider() && "velocity" in Target.ledge_cast_height_search.get_collider():
			Target.global_position.y = get_ledge_Y()+12
			Target.velocity.y = 0
			Target.velocity.x += Target.ledge_cast_height_search.get_collider().velocity.x * 2
		else:
			Target.velocity.y = 0
		Target.velocity.x += 4 * Target.facing
		apply_velocity(true)
	else:
		do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
		apply_velocity(true)
