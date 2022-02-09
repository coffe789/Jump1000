# Transit Conditions
# Holds the functions which determine if a state transition can occur
# These functions can be anywhere, but I find it convenient to put them all in 1 place
extends Node
var target

func _ready():
	get_parent().connect("activate",self,"on_activate")

func on_activate():
	target = get_parent().target

func is_grounded():
	return target.is_on_floor()

func is_airborne():
	return !target.is_on_floor()

func is_to_idle():
	return is_grounded() && get_input_direction() == 0


func is_to_walk():
	return is_grounded() && get_input_direction() != 0


func is_to_fall():
	return target.velocity.y >= 0


func is_to_jump():
	return Input.get_action_strength("ui_up") && is_grounded()

# Utility only functions: #
#-------------------------#
func get_input_direction():
	return (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
