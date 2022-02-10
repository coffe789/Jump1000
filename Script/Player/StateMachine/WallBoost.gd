extends "res://Script/Player/StateMachine/JumpState.gd"

func _ready():
	# TODO this hasn't been tested in a century
	move_accel = ACCELERATE_WALK * WALLJUMP_SLOWDOWN_MULTIPLIER * 1.2

func _enter():
	get_parent()._enter()
	Target.velocity.y = -JUMP_SPEED * WALLBOUNCE_MULTIPLIER
	Target.Animation_Player.play("jumping")

func _update(delta):
	get_parent()._update(delta)
	set_dash_target()
