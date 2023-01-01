extends "RootState.gd"

func on_hit(_amount, properties, damage_source):
	var xdir = damage_source.facing # This will crash if the damage_source doesn't have this
	if properties.has(Globals.Dmg_properties.PLAYER_THRUST):
		damage_source.attack_response(Globals.NORMAL_STAGGER, self)
	if properties.has(Globals.Dmg_properties.PLAYER_TWIRL):
		Target.is_boinked = true
	if (properties.has(Globals.Dmg_properties.PLAYER_THRUST)):
		Target.velocity = Vector2(xdir * 100, -100)
	elif (properties.has(Globals.Dmg_properties.PLAYER_TWIRL)):
		Target.velocity = Vector2(xdir * 10, -300)
		damage_source.attack_response(Globals.NORMAL_STAGGER, self)
	if properties.has(Globals.Dmg_properties.DASH_ATTACK_UP) \
		or properties.has(Globals.Dmg_properties.DASH_ATTACK_UP):
		Target.queue_free()
		
func _update(_delta):
	Target.velocity.y += GRAVITY
	Target.velocity.y = min(Target.velocity.y, MAX_FALL_SPEED) # Cap fall speed
	Target.velocity = Target.move_and_slide(Target.velocity, Vector2.UP)
	if Target.is_on_floor():
		Target.queue_free()
	
