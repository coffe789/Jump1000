extends "res://Script/Player/StateMachine/RootState.gd"

# Only duck doesn't inherit
func _update(delta):
	do_attack()
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,FLOOR_DRAG, ACCELERATE_WALK)


func _choose_substate():
	if Input.is_action_pressed("down"):
		return $Duck
	if get_input_direction()==0:
		return $Idle
	if get_input_direction()!=0:
		return $Run
	# Roll is accessed directly
