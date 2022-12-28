extends "res://Content/Player/StateMachine/AirState.gd"
var mult = 1.0
func _update(delta):
	mult = 2.0 if conditions_lib.is_let_go() else 1.0 #ease into slide after letting go of ledge
	do_gravity(delta, MAX_FALL_SPEED * WALL_GRAVITY_FACTOR * mult, GRAVITY * 3.0)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	apply_velocity()

func set_cape_acceleration():
	Target.Cape.accel = Vector2(0,8)

func _exit():
	pass
