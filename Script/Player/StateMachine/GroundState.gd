extends "res://Script/Player/StateMachine/RootState.gd"

# Only duck doesn't inherit
func _update(delta):
	do_attack()
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,FLOOR_DRAG, ACCELERATE_WALK)

# TODO extend
func _choose_substate():
	return $Idle
