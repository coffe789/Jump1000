extends "res://Script/Player/StateMachine/AirState.gd"

const HURT_TIME = 0.3

func _enter():
	Target.allow_dash_target = true
	Target.velocity.x = set_if_lesser(Target.velocity.x, -Target.facing * 130)
	Target.velocity.y = -100
	Target.Timers.get_node("HurtStateTimer").start(HURT_TIME)

func _update(delta):
	do_attack()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK * WALLJUMP_SLOWDOWN_MULTIPLIER)
	Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)

func _exit():
	Target.allow_dash_target = false


# TODO test this as an air state.
#	 Might need to remove some transitions that give you control again
