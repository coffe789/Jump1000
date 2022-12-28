# This state is actually completely redundant (:
extends "res://Content/Player/StateMachine/LedgeState.gd"



func _update(delta):
	._update(delta)
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Target.velocity.x += 4 * Target.facing
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	apply_velocity(true)
