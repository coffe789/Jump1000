extends "res://Script/Player/StateMachine/AirState.gd"

func _update(delta):
	._update(delta)
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_attack()


func _choose_substate():
	if Target.is_ducking:
		return $DuckFall
	if Target.is_spinning:
		return $SpinFall
	return $NormalFall

func _add_transitions():
	._add_transitions()
	transitions.append(StateTransition.new(
		+1,"to_coyote_jump",SM.get_node("RootState/AirState/JumpState"),funcref(conditions_lib,"is_coyote_jump")))
