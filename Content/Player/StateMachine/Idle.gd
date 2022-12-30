extends "res://Content/Player/StateMachine/GroundState.gd"

func _enter():
	._enter()
	Target.Animation_Player.conditional_play("idle")

func _update(delta):
	._update(delta)
	do_normal_x_movement(delta,FLOOR_DRAG, ACCELERATE_WALK)
	apply_velocity()
