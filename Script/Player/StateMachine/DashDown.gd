extends "res://Script/Player/StateMachine/DashState.gd"

func _ready():
	state_damage_properties = [
	Globals.Dmg_properties.FROM_PLAYER,
	Globals.Dmg_properties.DASH_ATTACK_DOWN
]

func _enter():
	._enter()
	SM.is_spinning = true
	Target.velocity.y = +DASH_SPEED_Y/3

func _update(delta):
	Target.velocity.y = approach(Target.velocity.y, +DASH_SPEED_Y/3, GRAVITY)
	._update(delta)

func _add_transitions():
	._add_transitions()
	transitions.append(StateTransition.new(
		+3,"to_superjump",SM.get_node("RootState/AirState/JumpState/SuperJump")
		,funcref(conditions_lib,"is_grounded_jump")))

func _exit():
	._exit()
	SM.is_spinning = false
