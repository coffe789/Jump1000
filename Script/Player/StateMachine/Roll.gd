extends "res://Script/Player/StateMachine/GroundState.gd"

var roll_direction

func _on_activate():
	pass

func _enter():
	Target.Animation_Player.play("rolling")
	if get_input_direction() == 0:
		roll_direction = Target.facing
	else:
		roll_direction = get_input_direction()
	Target.Timers.get_node("RollTimer").start(ROLL_TIME)
	Target.is_spinning = true

func _update(delta):
	._update(delta)
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)


func _exit():
	Target.is_spinning = false


#TODO attacking cancels the roll

#func _add_transitions():
#	pass # xd
