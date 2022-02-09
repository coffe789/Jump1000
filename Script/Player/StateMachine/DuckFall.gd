extends "res://Script/Player/StateMachine/FallState.gd"

func _update(delta):
	get_parent()._udpate(delta)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
