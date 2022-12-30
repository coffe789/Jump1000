extends "res://Content/Entities/Enemies/Beetle/RootState.gd"

func _choose_substate():
	if conditions_lib.is_flung():
		return $DeadFlung
	return $DeadNormal

func _enter():
	Target.get_node("Hitbox").monitorable = false
	Target.get_node("Hitbox").monitoring = false
	Target.get_node("Hitbox").damage_properties = [
		Globals.Dmg_properties.FROM_PLAYER
	]

func _update(_delta):
		if (Target.is_on_floor()): Target.velocity.x *= 0.75
		Target.velocity.y += GRAVITY
		do_movement()

func on_hit(_amount, properties, damage_source):
	# Self response
	var xdir = damage_source.facing
	if (properties.has(Globals.Dmg_properties.PLAYER_THRUST)):
		Target.velocity = Vector2(xdir * 150, -100)
	elif (properties.has(Globals.Dmg_properties.DASH_ATTACK_UP)):
		Target.velocity = Vector2(xdir * 150, -170)
		Target.is_flung = true
	elif (properties.has(Globals.Dmg_properties.DASH_ATTACK_DOWN)):
		Target.velocity = Vector2(xdir * 200, 200)
		Target.is_flung = true
	elif (properties.has(Globals.Dmg_properties.PLAYER_TWIRL)):
		if Target.is_dead:
			Target.velocity = Vector2(Target.velocity.x + xdir * 10, -250)
		else:
			Target.velocity = Vector2(xdir * 10, -250)
	elif damage_source is Beetle:
		xdir = sign(damage_source.velocity.x)
		Target.velocity = Vector2(xdir * 100, -100)

	# Player Response
	if (properties.has(Globals.Dmg_properties.DASH_ATTACK_UP)
		or properties.has(Globals.Dmg_properties.DASH_ATTACK_DOWN
		)):
		damage_source.attack_response(Globals.DASH_BONK_MINI, self)
	if (properties.has(Globals.Dmg_properties.PLAYER_THRUST) 
			or properties.has(Globals.Dmg_properties.PLAYER_TWIRL)):
		damage_source.attack_response(Globals.NORMAL_STAGGER, self)

