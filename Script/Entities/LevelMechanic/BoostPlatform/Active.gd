extends "res://Script/Entities/LevelMechanic/BoostPlatform/RootState.gd"

func _enter():
	Target.velocity = Vector2(10,-60)

func _update(delta):
	Target.velocity += Vector2(0,1)
	Target.position += Target.velocity/20
