extends "res://Script/Player/StateMachine/GroundState.gd"

func _enter():
	Player.Animation_Player.play("running")

func _update(delta):
	get_parent()._update()
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
