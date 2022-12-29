extends "res://Content/Entities/Enemies/Beetle/RootState.gd"

func _enter():
	pass

func _update(_delta):
	Target.velocity.y += GRAVITY
	do_movement()
