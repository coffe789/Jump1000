extends "res://Content/Entities/LevelMechanic/BoostPlatform/RootState.gd"

var is_in_stop_loop = false
var last_stop_pos


func _enter():
	pass

func on_collide(raycast):
	var point = raycast.get_collision_point()
	print(raycast.get_collider().collision_layer)
	Target.global_position.y = point.y - 12 # Platform height is 12 pixels
	SM.change_state(get_node("../Colliding"))

func _update(delta):
	if (Target.raycasts[0].get_collider() is PlatformCollider and Target.velocity.y > 0):
		 on_collide(Target.raycasts[0])
	elif (Target.raycasts[1].get_collider() is PlatformCollider and Target.velocity.y > 0):
		 on_collide(Target.raycasts[1])
	else:
		Target.velocity += Vector2(0,1)/20 * 60 * delta * 60
		Target.velocity.y = clamp(Target.velocity.y, -180, 120)
		Target.position += Target.velocity * delta

		Target.raycasts[0].cast_to = Target.velocity * delta
		Target.raycasts[1].cast_to = Target.velocity * delta
	
	if is_in_stop_loop:
		if abs(Target.global_position.x - last_stop_pos.x) < 1\
			and abs(Target.global_position.y - last_stop_pos.y) < 1:
				is_in_stop_loop = false
				SM.change_state(get_node("../Idle"))
	
	if SM.get_node("RumbleTimer").time_left == 0:
		Target.get_node("DustCloud").emitting = false
		Target.get_node("DustCloud2").emitting = false


func _on_TileProxy_area_entered(area):
	if area.is_in_group("platform_stop"):
		last_stop_pos = area.global_position + Vector2(-6,-6)
		Target.a(area.dir)
		is_in_stop_loop	= true


func _on_TileProxy_area_exited(area):
	if area.is_in_group("platform_stop"):
		is_in_stop_loop = false

func _collide(normal, collider):
	pass
