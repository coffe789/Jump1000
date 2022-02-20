# This state is actually completely redundant (:
extends "res://Script/Player/StateMachine/LedgeState.gd"



func _update(delta):
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Target.velocity.x += 2 * Target.facing
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
