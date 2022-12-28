extends "res://Content/Player/StateMachine/AirState.gd"

func _update(delta):
	._update(delta)
	do_attack()


func _choose_substate():
	if SM.is_ducking:
		return $DuckFall
	if SM.is_spinning && !SM.is_twirling:
		return $SpinFall
	return $NormalFall

func _add_transitions():
	._add_transitions()
	transitions.append(StateTransition.new(
		+1,"to_coyote_jump",SM.get_node("RootState/AirState/JumpState"),funcref(conditions_lib,"is_coyote_jump")))

