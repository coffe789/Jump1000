extends "res://Content/Entities/Enemies/Beetle/RootState.gd"

func _enter():
	Target.get_node("Hitbox").monitorable = false
	Target.get_node("Hitbox").monitoring = false
	
	SM.get_node("AnimationPlayer").play("dead")

func _update(_delta):
		if (Target.is_on_floor()): Target.velocity.x *= 0.75
		Target.velocity.y += GRAVITY
		do_movement()


func on_hit(_amount, properties, damage_source):
	var xdir = damage_source.facing
	if (properties.has(Globals.Dmg_properties.PLAYER_THRUST)):
		Target.velocity = Vector2(xdir * 150, -100)
	elif (properties.has(Globals.Dmg_properties.DASH_ATTACK_UP)):
		Target.velocity = Vector2(xdir * 150, -130)
	elif (properties.has(Globals.Dmg_properties.DASH_ATTACK_DOWN)):
		Target.velocity = Vector2(xdir * 200, 200)
	elif (properties.has(Globals.Dmg_properties.PLAYER_TWIRL)):
		if Target.is_dead:
			Target.velocity = Vector2(Target.velocity.x + xdir * 10, -250)
		else:
			Target.velocity = Vector2(xdir * 10, -250)

	if (properties.has(Globals.Dmg_properties.DASH_ATTACK_UP)
		or properties.has(Globals.Dmg_properties.DASH_ATTACK_DOWN
		)):
		damage_source.attack_response(Globals.DASH_BONK_MINI, self)

