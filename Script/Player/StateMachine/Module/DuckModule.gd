extends StateModule

func set_attack_ducking():
	Target.Attack_Box.get_child(0).get_shape().extents = root_state.NORMAL_ATTACK_SIZE
	Target.Attack_Box.position.y = -5
	Target.attack_box_x_distance = 11
func set_attack_normal():
	Target.Attack_Box.get_child(0).get_shape().extents = root_state.NORMAL_ATTACK_SIZE
	Target.Attack_Box.position.y = -8
	Target.attack_box_x_distance = 11


func enter():
	set_attack_ducking()
	root_state.set_y_collision(root_state.DUCKING_COLLISION_EXTENT,-4)
	if Target.Animation_Player.assigned_animation != "ducking":
		Target.Animation_Player.play("ducking")
	Target.is_ducking = true


func exit():
	Target.is_ducking = false
	set_attack_normal()
	root_state.set_y_collision(root_state.NORMAL_COLLISION_EXTENT,-8)

static func blacklist_transitions(from_state):
	from_state.remove_transition("to_wallslide")
	from_state.remove_transition("to_walljump")
	from_state.remove_transition("to_ledge")
	from_state.remove_transition("to_spinjump")
	from_state.remove_transition("to_dash")
