extends Trigger

func activate():
	Globals.get_player().state_list[Globals.get_player().current_state].take_damage(1)
