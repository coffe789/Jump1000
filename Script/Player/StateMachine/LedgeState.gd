extends "res://Script/Player/StateMachine/RootState.gd"
const LET_GO_TIME = 0.2

# Makes sure the player always rests at the same height
func get_ledge_Y():
	return Target.ledge_cast_height_search.get_collision_point().y


func check_buffered_inputs():
	pass


func set_facing_direction():
	pass


# Tell what you're clinging to that it is being clung to
# Useful for certain entities
func report_ledge_collision():
	var col = Target.ledge_cast_height_search.get_collider()
	if col && col.has_method("collide_with"):
		col.collide_with(Target.ledge_cast_height_search.get_collision_normal(),Target)

func set_cape_acceleration():
	Target.Cape.accel = Vector2(0, 8)

func _choose_substate():
	if conditions_lib.is_ledge_rest():
		return $LedgeRest
	if conditions_lib.is_ledge_rise():
		return $LedgeRise
	return $LedgeFall


func _enter():
	SM.is_twirling = false
	SM.is_clinging = true
	Target.reparent(Target.ledge_cast_height_search.get_collider())

func _update(_delta):
	report_ledge_collision()
	record_wall_velocity(Target.facing)
	if Input.is_action_just_pressed("down"):
		Target.get_node("Timers/LetGoTimer").start(LET_GO_TIME)

func _exit():
	SM.is_clinging = false
	Target.reparent(Target.current_area)

func _add_transitions():
	transitions.append(StateTransition.new(
		+1,"to_ground",SM.get_node("RootState/GroundState"),funcref(conditions_lib,"is_grounded")))
	transitions.append(StateTransition.new(
		0,"to_spinjump",SM.get_node("RootState/AirState/JumpState/SpinJump"),funcref(conditions_lib,"is_ledge_jump")))
	transitions.append(StateTransition.new(
		-1,"to_ledgerest",SM.get_node("RootState/LedgeState/LedgeRest"),funcref(conditions_lib,"is_ledge_rest")))
	transitions.append(StateTransition.new(
		-2,"to_normalfall",SM.get_node("RootState/AirState/FallState/NormalFall"),funcref(conditions_lib,"is_ledge_exit")))
