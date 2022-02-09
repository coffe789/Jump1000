extends "res://Script/Player/StateMachine/GroundState.gd"

func _update(delta):
	get_parent()._update()
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
