extends "res://Script/Player/StateMachine/GroundState.gd"
var DuckModule = preload("res://Script/Player/StateMachine/Module/DuckModule.gd")

func _on_activate():
	DuckModule = DuckModule.new()
	DuckModule.Target = Target
	DuckModule.SM = SM
	DuckModule.root_state = SM.get_node("RootState")

func _enter():
	._enter()
	DuckModule.enter()

func _exit():
	DuckModule.exit()

func _update(delta):
	._update(delta)
	do_normal_x_movement(delta, DUCK_FLOOR_DRAG, 0)
	apply_velocity()
