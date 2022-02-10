extends "res://Script/Player/StateMachine/DashState.gd"

func _ready():
	state_damage_properties = [
	Globals.Dmg_properties.FROM_PLAYER,
	Globals.Dmg_properties.DASH_ATTACK_DOWN
]

func _enter():
	get_parent()._enter()
	Target.velocity.y = +DASH_SPEED_Y
