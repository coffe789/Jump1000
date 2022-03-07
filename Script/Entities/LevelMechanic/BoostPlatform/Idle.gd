extends "res://Script/Entities/LevelMechanic/BoostPlatform/RootState.gd"

func _collide():
	SM.change_state(SM.get_node("RootState/Rumble"))
