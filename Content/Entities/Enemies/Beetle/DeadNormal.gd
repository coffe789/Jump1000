extends "res://Content/Entities/Enemies/Beetle/Dead.gd"

func _enter():
	._enter()
	Target.get_node("Hitbox").damage_amount = 0
	SM.get_node("AnimationPlayer").play("dead")
