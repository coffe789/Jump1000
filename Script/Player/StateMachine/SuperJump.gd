extends "res://Script/Player/StateMachine/JumpState.gd"

func _enter():
	._enter()
	play_jump_audio()
	Target.velocity.y = -JUMP_SPEED
	Target.Animation_Player.play("jumping")
	var dir = Target.facing if get_input_direction()==0 else get_input_direction()
	Target.velocity.x = set_if_lesser(Target.velocity.x, dir*230) # Previously used roll_direction. Not tested.

func _update(delta):
	._update(delta)
	set_dash_target()
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
