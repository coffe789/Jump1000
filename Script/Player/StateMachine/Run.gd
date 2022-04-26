extends "res://Script/Player/StateMachine/GroundState.gd"

func _enter():
	Target.Animation_Player.play("running")

func _update(delta):
	._update(delta)
	do_normal_x_movement(delta,FLOOR_DRAG, ACCELERATE_WALK)
	apply_velocity()
