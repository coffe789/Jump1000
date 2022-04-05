extends "res://Script/Entities/LevelMechanic/BoostPlatform/RootState.gd"

func _enter():
	Target.velocity = Vector2(10,-60)/20

func _update(delta):
	Target.velocity += Vector2(0,1)/20 * delta *60
	Target.position += Target.velocity
