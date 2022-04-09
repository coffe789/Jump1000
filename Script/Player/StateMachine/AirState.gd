extends "res://Script/Player/StateMachine/RootState.gd"


# TODO add wallslide?
func _choose_substate():
	return $FallState

 # Wallslide doesn't inherit
func _update(delta):
	set_dash_direction()
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)

# Not inherited by duck states and wallslide
func _exit():
	Target.allow_dash_target = false

func _check_buffered_inputs():
	._check_buffered_inputs()
	check_buffered_dash_input()


func _add_transitions():
	transitions.append(StateTransition.new(
		+2,"to_spinjump",SM.get_node("RootState/AirState/JumpState/SpinJump"),funcref(conditions_lib,"is_ledge_jump"),
		true))
	transitions.append(StateTransition.new(
		+1,"to_groundedjump",SM.get_node("RootState/AirState/JumpState"),funcref(conditions_lib,"is_grounded_jump")))
		
	transitions.append(StateTransition.new(
		0,"to_ground",SM.get_node("RootState/GroundState"),funcref(conditions_lib,"is_grounded")))
	transitions.append(StateTransition.new(
		-2,"to_ledge",SM.get_node("RootState/LedgeState"),funcref(conditions_lib,"is_on_ledge")))
	transitions.append(StateTransition.new(
		-3,"to_wallboost",SM.get_node("RootState/AirState/JumpState/WallBoost"),funcref(conditions_lib,"is_wallbounce")))
	transitions.append(StateTransition.new(
		-4,"to_walljump",SM.get_node("RootState/AirState/JumpState/WallJump"),funcref(conditions_lib,"is_walljump"),true))
	transitions.append(StateTransition.new(
		-5,"to_wallslide",SM.get_node("RootState/AirState/WallSlide"),funcref(conditions_lib,"is_wallslide")))
	transitions.append(StateTransition.new(
		-6,"to_dash",SM.get_node("RootState/AirState/DashState"),funcref(conditions_lib,"is_dash")))
	transitions.append(StateTransition.new(
		-10,"to_fallstate",SM.get_node("RootState/AirState/FallState"),funcref(conditions_lib,"is_falling")))
