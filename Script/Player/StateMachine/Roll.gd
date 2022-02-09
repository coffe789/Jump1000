extends "res://Script/Player/StateMachine/GroundState.gd"

var roll_direction

func _enter():
	Player.Animation_Player.play("rolling")
	if get_input_direction() == 0:
		roll_direction = Player.facing
	else:
		roll_direction = get_input_direction()
	Player.Timers.get_node("RollTimer").start(ROLL_TIME)

func _update(delta):
	get_parent()._update()
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

#TODO attacking cancels the roll
