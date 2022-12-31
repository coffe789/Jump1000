extends "RootState.gd"

var old_velocity : Vector2

func _enter():
	old_velocity = Target.velocity

func _exit():
	Target.velocity = old_velocity

func _update(_delta):
	Target.velocity = Target.move_and_slide(Vector2.ZERO, Vector2.UP)
	
func _add_transitions():
	._add_transitions()
