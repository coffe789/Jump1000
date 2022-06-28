extends "res://Script/Entities/LevelMechanic/BoostPlatform/RootState.gd"

var is_in_stop_loop = false
var last_stop_pos

func _enter():
	Target.velocity = Target.init_velocity
	SM.get_node("Timer").start(0.5)

func _update(delta):
	Target.velocity += Vector2(0,1)/20 * 60 * delta * 60
	Target.velocity.y = clamp(Target.velocity.y, -180, 120)
	Target.position += Target.velocity * delta
	
	if is_in_stop_loop:
		if abs(Target.global_position.x - last_stop_pos.x) <= 1\
			and abs(Target.global_position.y - last_stop_pos.y) <= 1:
				is_in_stop_loop = false
				SM.change_state(get_node("../Idle"))
	
	if SM.get_node("Timer").time_left == 0:
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
