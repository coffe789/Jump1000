extends Resource
class_name StateModule
var state # State that owns this module
var SM
var root_state
var Target

func _enter():
	pass

func _update():
	pass

func _exit():
	pass

func _add_state_transitions():
	pass

func _blacklist_transitions():
	pass

func _on_activated():
	state.default_anim = "ducking"
