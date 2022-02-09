extends "res://Script/Player/StateMachine/JumpState.gd"

func _enter():
	get_parent()._enter()
	Target.velocity.y = -JUMP_SPEED
	Target.Animation_Player.play("jumping")
	set_if_lesser(Player.velocity.x, Target.facing*250) # Previously used roll_direction. Not tested.

func _update(delta):
	get_parent()._update(delta)
	set_dash_target()
