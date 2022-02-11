extends StateMachine

func _ready():
	self.connect("before_updated",self, "on_before_update")
	self.connect("updated",self,"on_update")
	self.connect("changed_state",self, "on_change_state")

func on_before_update():
	current_state.check_buffered_inputs()

func on_update():
	current_state.set_facing_direction()
	current_state.set_cape_acceleration()
	current_state.set_player_sprite_direction()
	current_state.set_attack_direction()
	current_state.set_ledge_ray_direction()

func on_change_state(_old,_new):
	print(_old.name+"->"+_new.name)
