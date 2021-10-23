extends Node2D
signal attack_response

func on_attacked():
	get_tree().call_group("player", "attack_response", 0)
	print("ouch")


func _on_AttackableArea_area_entered(area):
	if area.is_in_group("player_attack"):
		on_attacked()
