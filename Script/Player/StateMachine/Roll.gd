extends "res://Script/Player/StateMachine/GroundState.gd"

var roll_direction

func _enter():
	Target.Animation_Player.play("rolling")
	if get_input_direction() == 0:
		roll_direction = Target.facing
	else:
		roll_direction = get_input_direction()
	Target.Timers.get_node("RollTimer").start(ROLL_TIME)

func _update(delta):
	get_parent()._update(delta)
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)

#TODO attacking cancels the roll
