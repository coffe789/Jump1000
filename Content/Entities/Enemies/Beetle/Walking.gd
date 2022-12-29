extends "res://Content/Entities/Enemies/Beetle/RootState.gd"

func _enter():
	pass

	# TODO use Globals.approach() here
func _update(delta):
	if Target.is_on_floor():
		if Target.hp >= 4:
			Target.velocity.x = Globals.approach(Target.velocity.x, WALK_SPEED * Target.facing, (delta * 60) * WALK_SPEED / 4.0)
		else:
			Target.velocity.x = Globals.approach(Target.velocity.x, RUN_SPEED * Target.facing, (delta * 60) * RUN_SPEED / 4.0)

	Target.velocity.y += GRAVITY
	do_movement()

