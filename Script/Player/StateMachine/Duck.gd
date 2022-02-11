extends "res://Script/Player/StateMachine/GroundState.gd"
var DuckModule = preload("res://Script/Player/StateMachine/Module/DuckModule.gd")

func _on_activate():
	DuckModule = DuckModule.new()
	DuckModule.Target = Target
	DuckModule.SM = SM
	DuckModule.root_state = SM.get_node("RootState")

func _enter():
	DuckModule.enter()


func _exit():
	DuckModule.exit()


# Not inherited
func _update(delta):
	do_attack()
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, DUCK_FLOOR_DRAG, 0)
