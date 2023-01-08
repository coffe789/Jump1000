extends "res://Content/Entities/LevelMechanic/BoostPlatform/RootState.gd"
var old_layer = 0

func _enter():
	Target.is_respawning = true
	Target.get_node("DustCloud").emitting = true
	Target.get_node("DustCloud2").emitting = true
	Target.get_node("TileMap").visible = false
	Target.velocity = Vector2.ZERO
	old_layer = Target.collision_layer
	Target.set_deferred("collision_layer", 0)
	Target.position = Target.init_position
	yield(get_tree().create_timer(1), "timeout")
	
	Target.get_node("DustCloud").emitting = false
	Target.get_node("DustCloud2").emitting = false
	Target.get_node("TileMap").visible = true
	Target.set_deferred("collision_layer", old_layer)
	Target.is_respawning = false
	SM.change_state(get_node("../Idle"))
