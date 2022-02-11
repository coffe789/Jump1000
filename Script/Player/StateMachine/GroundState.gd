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
	if conditions_lib.is_roll():
		return $Roll
	if get_input_direction()==0:
		return $Idle
	if get_input_direction()!=0:
		return $Run

func _add_transitions():
	transitions.append(StateTransition.new(
		+2,"to_groundedjump",SM.get_node("RootState/AirState/JumpState"),funcref(conditions_lib,"is_grounded_jump")))
	transitions.append(StateTransition.new(
		+1,"to_fallstate",SM.get_node("RootState/AirState/FallState"),funcref(conditions_lib,"is_airborne")))
	transitions.append(StateTransition.new(
		-1,"to_ground",SM.get_node("RootState/GroundState"),funcref(conditions_lib,"is_grounded")))
