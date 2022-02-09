extends "res://Script/Player/StateMachine/FallState.gd"

func _update(delta):
	get_parent()._udpate(delta)
	set_dash_target()
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
