extends "res://Script/Player/StateMachine/FallState.gd"

func _enter():
	Target.Animation_Player.play("rolling")
	Target.is_spinning = true

func _update(delta):
	._update(delta)
	set_dash_target()
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)

func _add_transitions():
	._add_transitions()
	transitions.append(StateTransition.new(
		0,"to_ground",SM.get_node("RootState/GroundState/Roll"),funcref(conditions_lib,"is_grounded")))

func _exit():
	.exit()
	Target.is_spinning = false
