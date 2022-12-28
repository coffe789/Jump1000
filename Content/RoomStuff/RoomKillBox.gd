extends Area2D

func _on_KillBox_area_entered(area):
	if area.is_in_group("player_area"):
#		get_tree().paused = true
		Globals.get_player().respawn()
