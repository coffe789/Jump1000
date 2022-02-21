extends "res://Script/Player/StateMachine/FallState.gd"

func _enter():
	Target.Animation_Player.play("floating")
	Target.Animation_Player.queue("falling")

func _update(delta):
	._update(delta)
	if SM.is_twirling && Target.velocity.y > MAX_FALL_SPEED/6:
		do_gravity(delta, MAX_FALL_SPEED/6, GRAVITY*3)
	else:
		do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	set_dash_target()
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
