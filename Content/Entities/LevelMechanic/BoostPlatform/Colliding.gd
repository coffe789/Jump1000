extends "res://Content/Entities/LevelMechanic/BoostPlatform/RootState.gd"

func _enter():
	Target.velocity.y = 0
	Target.raycasts[0].cast_to = Vector2.DOWN
	Target.raycasts[1].cast_to = Vector2.DOWN

func _update(delta):
	Target.position += Target.velocity * delta
	Target.raycasts[0].force_raycast_update()
	Target.raycasts[1].force_raycast_update()
	if !Target.raycasts[0].is_colliding() && !Target.raycasts[1].is_colliding():
		SM.change_state(get_node("../Active"))
	
	if SM.get_node("RumbleTimer").time_left == 0:
		Target.get_node("DustCloud").emitting = false
		Target.get_node("DustCloud2").emitting = false
