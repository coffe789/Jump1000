extends Trigger

func activate():
	#Globals.get_player().state_list[Globals.get_player().current_state].take_damage(1)
	Globals.emit_signal("damage_player", 1)


func on_ready():
	pass
