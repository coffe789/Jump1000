extends "res://Script/Player/StateMachine/LedgeState.gd"

#TODO this has changed, make sure it works
func _update(delta):
	if get_ledge_Y()-Target.ledge_cast_top.global_position.y < 0:
		Target.velocity.y = 0
		Target.velocity.x = Target.move_and_slide(Target.velocity, UP_DIRECTION).x
	else:
		do_gravity(delta, MAX_FALL_SPEED * WALL_GRAVITY_FACTOR, GRAVITY * 1.5)
		do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
		Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
