extends "res://Script/Player/StateMachine/DashState.gd"

func _ready():
	state_damage_properties = [
	Globals.Dmg_properties.FROM_PLAYER,
	Globals.Dmg_properties.DASH_ATTACK_UP
]

func _enter():
	._enter()
	Target.velocity.y = -DASH_SPEED_Y