extends "res://Content/Player/StateMachine/DashState.gd"

func _ready():
	state_damage_properties = [
	Globals.Dmg_properties.FROM_PLAYER,
	Globals.Dmg_properties.DASH_ATTACK_UP
	]
	default_animation = "attacking"

func _enter():
	._enter()
	Target.velocity.y = -DASH_SPEED_Y

func _update(delta):
	Target.velocity.y = approach(Target.velocity.y, -DASH_SPEED_Y, GRAVITY)
	._update(delta)
