extends "res://Script/Player/StateMachine/LedgeState.gd"


func _update(delta):
	if get_ledge_Y()-Target.ledge_cast_top.global_position.y < 0:
		var pos = Target.global_position
		Target.get_parent().remove_child(Target)
		Target.ledge_cast_height_search.get_collider().add_child(Target)
		Target.global_position=pos
		Globals.emit_signal("player_connect_cam",Target)
		Target.Cape.set_physics_process(true)
		if Target.ledge_cast_height_search.get_collider() && "velocity" in Target.ledge_cast_height_search.get_collider():
			Target.velocity.y = Target.ledge_cast_height_search.get_collider().velocity.y
			Target.global_position.y = get_ledge_Y()+12
			Target.velocity.y = Target.ledge_cast_height_search.get_collider().velocity.y
			Target.velocity.x += Target.ledge_cast_height_search.get_collider().velocity.x * 2
		else:
			Target.velocity.y = 0
		Target.velocity.x += 4 * Target.facing
		Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)
		report_ledge_collision()
	else:
		do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
		Target.velocity = Target.move_and_slide(Target.velocity, UP_DIRECTION)



func _exit():
	var poso = Target.global_position
	Target.get_parent().remove_child(Target)
	Target.current_area.add_child(Target)
	Target.global_position = poso
	Globals.emit_signal("player_connect_cam",Target)
