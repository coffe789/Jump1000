extends "res://Script/Player/StateMachine/GroundState.gd"

func _on_activate():
	default_animation = "running"

func _enter():
	._enter()
	Target.Animation_Player.conditional_play("running")

func _update(delta):
	._update(delta)
	do_normal_x_movement(delta,FLOOR_DRAG, ACCELERATE_WALK)
	apply_velocity()
