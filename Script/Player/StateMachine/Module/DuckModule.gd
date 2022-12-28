extends StateModule

func _init(_state : State, _target : Node, _SM : StateMachine, _root_state : State):
	self.state = _state
	self.SM = _SM
	self.root_state = _root_state
	self.Target = _target

	state.default_animation = "ducking"

# TODO if you're attacking play duck/attack animation
func enter():
	root_state.set_y_collision(root_state.DUCKING_COLLISION_EXTENT,-4)
	if Target.Animation_Player.assigned_animation != "ducking":
		Target.Animation_Player.play("ducking")
	SM.is_ducking = true


func exit():
	SM.is_ducking = false
	root_state.set_y_collision(root_state.NORMAL_COLLISION_EXTENT,-8)

static func blacklist_transitions(from_state):
	from_state.remove_transition("to_wallslide")
	from_state.remove_transition("to_walljump")
	from_state.remove_transition("to_ledge")
	from_state.remove_transition("to_spinjump")
	from_state.remove_transition("to_dash")
