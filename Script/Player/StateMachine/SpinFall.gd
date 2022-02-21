extends "res://Script/Player/StateMachine/FallState.gd"

func _enter():
	Target.Animation_Player.play("rolling")
	SM.is_spinning = true

func _update(delta):
	._update(delta)
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	set_dash_target()
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)

func _exit():
	._exit()
	SM.is_spinning = false
