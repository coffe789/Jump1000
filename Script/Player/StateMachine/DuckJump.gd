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
	Target.velocity += get_boost()
	emit_jump_particles()

func _update(delta):
	._update(delta)
	apply_velocity(true)

func _exit():
	DuckModule.exit()

func _blacklist_transitions():
	DuckModule.blacklist_transitions(self)
