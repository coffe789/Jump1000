extends "res://Script/Player/StateMachine/FallState.gd"

func _enter():
	Target.Animation_Player.play("rolling")
	Target.is_spinning = true

func _update(delta):
	._update(delta)
	set_dash_target()
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)

func _exit():
	._exit()
	Target.is_spinning = false
