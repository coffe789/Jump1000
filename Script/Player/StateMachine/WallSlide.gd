extends "res://Script/Player/StateMachine/AirState.gd"

func _update(delta):
#	check_if_finish_jump() #TODO check this is fine
	do_gravity(delta, MAX_FALL_SPEED * WALL_GRAVITY_FACTOR, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)

func set_cape_acceleration():
	Target.Cape.accel = Vector2(0,8)

func _exit():
	pass

func _add_transitions():
	._add_transitions()
	transitions.append(StateTransition.new(
		-10,"to_fallstate",SM.get_node("RootState/AirState/FallState"),funcref(conditions_lib,"is_falling")))
