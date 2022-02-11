extends "res://Script/Player/StateMachine/JumpState.gd"
var DuckModule = preload("res://Script/Player/StateMachine/Module/DuckModule.gd")

func _on_activate():
	DuckModule = DuckModule.new()
	DuckModule.Target = Target
	DuckModule.SM = SM
	DuckModule.root_state = SM.get_node("RootState")

func _enter():
	._enter()
	DuckModule.enter()
	play_jump_audio()
	Target.velocity.y = -JUMP_SPEED

func _update(delta):
	._update(delta)
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)

func _exit():
	DuckModule.exit()

func _blacklist_transitions():
	DuckModule.blacklist_transitions(self)
