extends "res://Script/Player/StateMachine/GroundState.gd"

var roll_direction

func _enter():
	._enter()
	Target.Animation_Player.play("rolling")
	if get_input_direction() == 0:
		roll_direction = Target.facing
	else:
		roll_direction = get_input_direction()
	Target.Timers.get_node("RollTimer").start(ROLL_TIME)
	SM.is_spinning = true

func _update(delta):
	._update(delta)
	do_normal_x_movement(delta,FLOOR_DRAG, ACCELERATE_WALK)
	apply_velocity()
	
	if (Target.Timers.get_node("RollTimer").time_left == 0 
	or get_input_direction() != roll_direction):
		SM.is_spinning = false

func _exit():
	SM.is_spinning = false


#TODO attacking cancels the roll

