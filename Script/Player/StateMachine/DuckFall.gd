extends "res://Script/Player/StateMachine/FallState.gd"
var DuckModule = preload("res://Script/Player/StateMachine/Module/DuckModule.gd")

func _on_activate():
	DuckModule = DuckModule.new()
	DuckModule.Target = Target
	DuckModule.SM = SM
	DuckModule.root_state = SM.get_node("RootState")

func _enter():
	DuckModule.enter()

func _update(delta):
	._update(delta)
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	apply_velocity()


func _exit():
	DuckModule.exit()

func _blacklist_transitions():
	DuckModule.blacklist_transitions(self)
