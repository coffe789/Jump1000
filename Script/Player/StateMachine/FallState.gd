extends "res://Script/Player/StateMachine/AirState.gd"

func _update(delta):
	get_parent()._update(delta)
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_attack()

#TODO extend
func _choose_substate():
	return $NormalFall

#func _add_transitions():
#	pass
