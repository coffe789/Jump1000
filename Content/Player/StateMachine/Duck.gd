extends "res://Content/Player/StateMachine/GroundState.gd"
var DuckModule = preload("res://Content/Player/StateMachine/Module/DuckModule.gd")

func _on_activate():
	DuckModule = DuckModule.new(self, Target, SM, SM.get_node("RootState"))

func _enter():
	._enter()
	DuckModule.enter()

func _exit():
	DuckModule.exit()

func _update(delta):
	._update(delta)
	do_normal_x_movement(delta, DUCK_FLOOR_DRAG, 0)
	apply_velocity()
