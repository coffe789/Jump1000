extends StateMachine

func _ready():
	self.connect("updated",self,"on_update")

func on_update():
	current_state.set_facing_direction()
	current_state.set_cape_acceleration()
	current_state.set_player_sprite_direction()
	current_state.set_attack_direction()
	current_state.check_buffered_inputs()
	current_state.set_ledge_ray_direction()
	print(current_state)
