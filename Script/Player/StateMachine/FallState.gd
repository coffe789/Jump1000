extends "res://Script/Player/StateMachine/AirState.gd"

func _update(delta):
	._update(delta)
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_attack()

#TODO extend
func _choose_substate():
	if Target.is_ducking:
		return $DuckFall
	if Target.is_spinning:
		return $SpinFall
	return $NormalFall

#func _add_transitions():
#	pass
