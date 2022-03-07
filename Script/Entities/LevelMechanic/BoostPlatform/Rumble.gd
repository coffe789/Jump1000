extends "res://Script/Entities/LevelMechanic/BoostPlatform/RootState.gd"
var timer

func _on_activate():
	timer = SM.get_node("Timer")

func _enter():
	timer.start(0.3)

func _update(_delta):
	if timer.time_left == 0:
		SM.change_state(SM.get_node("RootState/Active"))
