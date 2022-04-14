extends "res://Script/Entities/LevelMechanic/BoostPlatform/RootState.gd"

func _collide():
	if SM.get_node("Timer").time_left==0:
		SM.change_state(SM.get_node("RootState/Rumble"))

func _enter():
	Target.get_node("DustCloud2").emitting = false
	Target.get_node("DustCloud").emitting = false
	Target.get_node("TileMap").material.set("shader_param/is_active",false) # otherwise parameter survives queue_free()
	SM.get_node("Timer").start(0.2) # You can't activate until timer is done
