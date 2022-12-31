extends TransitConditions

func is_boinked(): return Target.is_boinked

func is_stunned():
	return Target.get_node("StunTimer").time_left != 0

func is_not_stunned():
	return not is_stunned()
