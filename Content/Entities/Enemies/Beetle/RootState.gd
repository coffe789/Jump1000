extends State
const GRAVITY = 9.8
const WALK_SPEED = 25
const RUN_SPEED = 55
const MAX_FALL_SPEED = 200

func _choose_substate():
	return $Walking
##if Target.is_on_floor():
##	return $Walking
##else:
##	return $Airborne



func _add_transitions():
	transitions.append(StateTransition.new(
		2,"to_dead",SM.get_node("RootState/Dead"),funcref(conditions_lib,"is_dead")))
	transitions.append(StateTransition.new(
		1,"to_airborne",SM.get_node("RootState/Airborne"),funcref(conditions_lib,"is_airborne")))
	transitions.append(StateTransition.new(
		0,"to_walking",SM.get_node("RootState/Walking"),funcref(conditions_lib,"is_grounded")))

func do_movement():
	Target.velocity.y = min(Target.velocity.y, MAX_FALL_SPEED) # Cap fall speed

	var prev_speed = Target.velocity
	Target.velocity = Target.move_and_slide(Target.velocity, Vector2.UP)

	if prev_speed.y > GRAVITY * 4 && Target.is_on_floor(): # Bounce off walls and floor
		Target.velocity.y = -prev_speed.y * 0.5
	if Target.is_on_wall():
		Target.velocity.x = -prev_speed.x * 0.4

# hit the player
func on_hit(_amount, properties, damage_source):
	var xdir = damage_source.facing # This will crash if the damage_source doesn't have this
	if (properties.has(Globals.Dmg_properties.PLAYER_THRUST)):
		Target.velocity = Vector2(xdir * 100, -100)
	elif (properties.has(Globals.Dmg_properties.PLAYER_TWIRL)):
		Target.velocity = Vector2(xdir * 10, -200)
	elif (properties.has(Globals.Dmg_properties.DASH_ATTACK_UP)
		or properties.has(Globals.Dmg_properties.DASH_ATTACK_DOWN
		)):
		Target.velocity = Vector2(xdir * 100, -100)
		damage_source.attack_response(Globals.DASH_BONK, self)	
	elif damage_source is Beetle:
		xdir = sign(damage_source.velocity.x)
		Target.velocity = Vector2(xdir * 100, -100)
	
	if (properties.has(Globals.Dmg_properties.PLAYER_THRUST) 
			or properties.has(Globals.Dmg_properties.PLAYER_TWIRL)):
		damage_source.attack_response(Globals.NORMAL_STAGGER, self)
