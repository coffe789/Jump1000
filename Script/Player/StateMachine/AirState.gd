extends "res://Script/Player/StateMachine/RootState.gd"


#TODO add wallslide
func _choose_substate():
	return $FallState

func _update(delta):
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	set_dash_direction()
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
