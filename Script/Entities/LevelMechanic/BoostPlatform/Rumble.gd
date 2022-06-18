extends "res://Script/Entities/LevelMechanic/BoostPlatform/RootState.gd"
onready var XRumble = "res://Resource/Shader/XRumble.tres"
var timer
var RUMBLE_TIME = 0.0

func _on_activate():
	timer = SM.get_node("Timer")

func _enter():
	timer.start(RUMBLE_TIME)
	Target.get_node("TileMap").material.set("shader_param/is_active",true)
	Target.get_node("DustCloud").emitting = true
	Target.get_node("DustCloud2").emitting = true
	Target.get_node("AnimationPlayer").play("activate")

func _exit():
	Target.get_node("TileMap").material.set("shader_param/is_active",false)

func _update(_delta):
	if timer.time_left == 0:
		SM.change_state(SM.get_node("RootState/Active"))
