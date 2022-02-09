extends Node

onready var target = get_node("../..")
var root_state
var HFSM

func is_grounded():
	return target.is_on_floor()

func is_airborne():
	return !target.is_on_floor()

func is_falling():
	return target.velocity.y >= 0
