extends "res://Content/Player/StateMachine/FallState.gd"

func _on_activate():
	default_animation = "rolling"

func _enter():
	Target.Animation_Player.conditional_play("rolling")
	SM.is_spinning = true

func _update(delta):
	._update(delta)
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	set_dash_target()
	apply_velocity()

func _exit():
	._exit()
	SM.is_spinning = false
