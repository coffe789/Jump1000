extends "res://Script/Player/StateMachine/JumpState.gd"

func _ready():
	# TODO this hasn't been tested in a century
	move_accel = ACCELERATE_WALK * WALLJUMP_SLOWDOWN_MULTIPLIER * 1.2

func _enter():
	._enter()
	Target.velocity.y = -JUMP_SPEED * WALLBOUNCE_MULTIPLIER
	Target.Animation_Player.play("jumping")
	play_walljump_audio()
	emit_jump_particles(true)

func _update(delta):
	._update(delta)
	set_dash_target()
	apply_velocity(true)
