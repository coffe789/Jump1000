extends "res://Script/Player/StateMachine/LedgeState.gd"


func _update(delta):
	Target.velocity.x += 2 * Target.facing
	Target.velocity.y = -10
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
