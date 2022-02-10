extends Node

onready var Target = get_node("../..")
onready var root_state = get_node("../RootState")
var HFSM = get_parent()

func is_hold_down():
	return Input.is_action_pressed("down")

func is_grounded():
	return Target.is_on_floor()

func is_airborne():
	return !Target.is_on_floor()

func is_falling():
	return Target.velocity.y >= 0

#TODO get rid of global stuff and maybe even this dumb function
func is_on_ledge():
	return root_state.get_ledge_behaviour() != Globals.LEDGE_EXIT
func is_ledge_exit():
	return root_state.get_ledge_behaviour() == Globals.LEDGE_EXIT
func is_ledge_rest():
	return root_state.get_ledge_behaviour() == Globals.LEDGE_REST
func is_ledge_fall():
	return root_state.get_ledge_behaviour() == Globals.LEDGE_NO_ACTION
func is_ledge_rise():
	return root_state.get_ledge_behaviour() == Globals.LEDGE_LENIENCY_RISE

func is_grounded_jump():
	return (Input.is_action_just_pressed("jump") || Target.isJumpBuffered)\
		&& Target.is_on_floor()

func is_ledge_jump():
	return (Target.get_ledge_behaviour() != Globals.LEDGE_EXIT)\
		&& (Input.is_action_just_pressed("jump") or Target.isJumpBuffered)

func is_walljump():
	return root_state.can_wall_jump() && (Input.is_action_just_pressed("jump") or Target.isJumpBuffered)

func is_wallbounce():
	return Target.Timers.get_node("WallBounceTimer").time_left > 0 && Target.velocity.y < 0\
		&& is_walljump()

func is_wallslide():
	return Target.wall_direction == root_state.get_input_direction() && Target.wall_direction != 0\
		&& Target.directionY < 0\
		&& Target.Timers.get_node("PostClingJumpTimer").time_left == 0

func is_dash():
	return (Input.is_action_just_pressed("attack")\
	 || Target.Timers.get_node("BufferedRedashTimer").time_left > 0\
	 || Target.Timers.get_node("BufferedDashTimer").time_left > 0)\
	 && Target.Timers.get_node("NoDashTimer").time_left == 0

func is_dash_up():
	return is_dash() && Target.dash_direction == -1
func is_dash_down():
	return is_dash() && Target.dash_direction == +1
