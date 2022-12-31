extends "RootState.gd"
var turn_timer : Timer

func _on_activate():
	turn_timer = Target.get_node("TurnTimer")
	turn_timer.connect("timeout", self, "on_timeout")
	turn_timer.start(turn_time)

func on_timeout():
	if SM.current_state == self:
		turn_around()

func _enter():
	turn_timer.paused = false

func _exit():
	turn_timer.paused = true

func _update(delta):
	Target.velocity = Target.direction * min((Target.velocity + (Target.direction * ACCELERATION * delta)).length(), MAX_SPEED)
	Target.velocity = Target.move_and_slide(Target.velocity, Vector2.UP)

