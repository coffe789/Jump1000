extends "res://Script/Player/StateMachine/JumpState.gd"

func _enter():
	get_parent()._enter()
	Target.velocity.y = -JUMP_SPEED
	play_jump_audio()
	Target.Animation_Player.play("jumping")

func _update(delta):
	get_parent()._update(delta)
	set_dash_target()
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
