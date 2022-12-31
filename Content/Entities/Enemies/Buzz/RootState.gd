extends State
export var turn_time = 1.25

const MAX_SPEED = 60 
const ACCELERATION = 20
const STUN_TIME = 0.4

func _choose_substate():
	return $Flying

func turn_around():
	if Target.direction.x != 0:
		Target.get_node("Sprite").scale.x *= -1
	Target.direction *= -1
	Target.get_node("TurnTimer").start(turn_time)

func on_hit(_amount, properties, _damage_source):
	if properties.has(Globals.Dmg_properties.PLAYER_THRUST):
		Target.is_stunned = true
	if properties.has(Globals.Dmg_properties.PLAYER_TWIRL):
		Target.is_boinked = true
	if properties.has(Globals.Dmg_properties.DASH_ATTACK_UP) \
		or properties.has(Globals.Dmg_properties.DASH_ATTACK_UP):
		Target.get_node("StunTimer").start(STUN_TIME)

func _add_transitions():
	transitions.append(StateTransition.new(
		2,"to_boinked",SM.get_node("RootState/Boinked"),
		funcref(conditions_lib,"is_boinked")))
	transitions.append(StateTransition.new(
		1,"to_stunned",SM.get_node("RootState/Stunned"),
		funcref(conditions_lib,"is_stunned")))
	transitions.append(StateTransition.new(
		0,"to_flying",SM.get_node("RootState/Flying"),
		funcref(conditions_lib,"is_not_stunned")))
