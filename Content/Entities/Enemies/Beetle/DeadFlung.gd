extends "res://Content/Entities/Enemies/Beetle/Dead.gd"

func _enter():
	._enter()
	# SM.get_node("AnimationPlayer").play("flung")
	Target.get_node("Hitbox").monitorable = true
	Target.get_node("Hitbox").monitoring = true
	Target.get_node("Hitbox").damage_amount = 2
	print("FLUG")

func _update(delta):
	._update(delta)
	if (Target.is_flung and Target.is_on_floor()):
		Target.is_flung = false
		Target.get_node("FlungTimer").start(0.35)



func _exit():
	Target.is_flung = false
	print("FLUGNT")
