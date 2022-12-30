extends TransitConditions

func is_dead():
	return Target.is_dead

func is_grounded():
	return Target.is_on_floor()

func is_airborne():
	return !is_grounded()

func is_flung():
	return Target.get_node("FlungTimer").time_left > 0 || Target.is_flung
