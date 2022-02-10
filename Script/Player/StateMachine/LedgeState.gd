extends "res://Script/Player/StateMachine/RootState.gd"

# Makes sure the player always rests at the same height
func get_ledge_Y():
	return Target.ledge_cast_height_search.get_collision_point().y

# Tell what you're clinging to that it is being clung to
# Useful for certain entities
func report_collision():
	var col = Target.ledge_cast_height_search.get_collider()
	if col && col.has_method("collide_with"):
		col.collide_with(Target.ledge_cast_height_search.get_collision_normal(),Target)

func set_cape_acceleration():
	Target.Cape.accel = Vector2(0, 8)

func _choose_substate():
	if conditions_lib.is_ledge_rest():
		return $LedgeRest
	if conditions_lib.is_ledge_fall():
		return $LedgeFall
	if conditions_lib.is_ledge_rise():
		return $LedgeRise
