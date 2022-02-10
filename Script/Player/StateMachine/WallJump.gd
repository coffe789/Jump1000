extends "res://Script/Player/StateMachine/JumpState.gd"

func _ready():
	move_accel = ACCELERATE_WALK * WALLJUMP_SLOWDOWN_MULTIPLIER


func _enter():
	get_parent()._enter()
	Target.Animation_Player.play("jumping")
	Target.velocity.x = set_if_lesser(
		Target.velocity.x, MAX_X_SPEED*(-Target.wall_direction) * WALLJUMP_X_SPEED_MULTIPLIER
		)


func _update(delta):
	get_parent()._update(delta)
	Target.velocity.y = -JUMP_SPEED
	set_dash_target()
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
