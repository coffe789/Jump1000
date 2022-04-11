extends "res://Script/Entities/LevelMechanic/BoostPlatform/RootState.gd"

func _enter():
	Target.velocity = Target.init_velocity
	SM.get_node("Timer").start(0.5)

func _update(delta):
	Target.velocity += Vector2(0,1)/20 * delta *60
	Target.velocity.y = clamp(Target.velocity.y, -3, 2)
	Target.position += Target.velocity
	if SM.get_node("Timer").time_left == 0:
		Target.get_node("DustCloud").emitting = false
		Target.get_node("DustCloud2").emitting = false
