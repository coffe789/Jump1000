extends "res://Content/Player/StateMachine/JumpState.gd"

func _ready():
	move_accel = ACCELERATE_WALK * WALLJUMP_SLOWDOWN_MULTIPLIER


func _enter():
	._enter()
	Target.velocity.y = -JUMP_SPEED
	Target.Animation_Player.conditional_play("jumping")
	Target.velocity.x = set_if_lesser(
		Target.velocity.x, MAX_X_SPEED*(-Target.wall_direction) * WALLJUMP_X_SPEED_MULTIPLIER
		)
	play_walljump_audio()
	emit_jump_particles(true)


func _update(delta):
	._update(delta)
	set_dash_target()
	apply_velocity(true)
